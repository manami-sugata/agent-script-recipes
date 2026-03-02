public with sharing class AgentIdentityActionforAgentforce {

    public class Input {
        @InvocableVariable public String bondNumber;
        @InvocableVariable public String name;
        @InvocableVariable public String address;
        @InvocableVariable public String telNumber;
        @InvocableVariable public String birth;
        @InvocableVariable public Integer bondAttempts;
        @InvocableVariable public Integer nameAttempts;
        @InvocableVariable public Boolean inFourItemsMode;
    }

    public class Output {
        @InvocableVariable public String nextTemplateKey;
        @InvocableVariable public Boolean verified;
        @InvocableVariable public String message;
        @InvocableVariable public Boolean inFourItemsMode;
        @InvocableVariable public Integer bondAttempts;
        @InvocableVariable public Integer nameAttempts;
        @InvocableVariable public String correctedBondNumber;
        @InvocableVariable public String contractSummary;
    }

    @InvocableMethod(label='本人確認（4項目/証券番号併用、強制4項目フォールバック付）Agentforce用')
    public static List<Output> run(List<Input> inputs) {
        List<Output> results = new List<Output>();
        if (inputs == null) {
            return results;
        }

        for (Input item : inputs) {
            Output out = new Output();

            Integer bCnt = (item.bondAttempts == null ? 0 : item.bondAttempts);
            Integer nCnt = (item.nameAttempts == null ? 0 : item.nameAttempts);
            Boolean four = (item.inFourItemsMode == null ? false : item.inFourItemsMode);

            String bond = IdentityVerification.normalize(item.bondNumber);
            String name = IdentityVerification.normalize(item.name);
            String addr = IdentityVerification.normalizeAddress(item.address);
            String tel  = IdentityVerification.normalizeTel(item.telNumber);
            String dob  = IdentityVerification.normalizeBirth(item.birth);

            out.bondAttempts = bCnt;
            out.nameAttempts = nCnt;
            out.inFourItemsMode = four;
            out.correctedBondNumber = null;
            out.contractSummary = null;

            // 強制4項目へのフォールバック
            Boolean allFourFilled = !String.isBlank(name) && !String.isBlank(addr) && !String.isBlank(tel) && !String.isBlank(dob);
            if (!four && String.isBlank(bond) && allFourFilled) {
                four = true;
                out.inFourItemsMode = true;
            }

            // 4項目モード
            if (four) {
                if (String.isBlank(name)) {
                    setResp(out, 'PT_NAME_ASK', 'ask name (4-items mode)');
                    results.add(out);
                    continue;
                }
                if (String.isBlank(tel)) {
                    setResp(out, 'PT_TEL_ASK', 'ask tel (4-items mode)');
                    results.add(out);
                    continue;
                }
                if (String.isBlank(addr)) {
                    setResp(out, 'PT_ADDR_ASK', 'ask address (4-items mode)');
                    results.add(out);
                    continue;
                }
                if (String.isBlank(dob)) {
                    setResp(out, 'PT_DOB_ASK', 'ask birth (4-items mode)');
                    results.add(out);
                    continue;
                }

                Boolean ok = IdentityVerificationforAgentforce.verifyIdentityFinal('', name, addr, tel, dob);
                if (!ok) {
                    setVerify(out, false, 'verified NG (4-items)');
                    results.add(out);
                    continue;
                }

                String correctBond = IdentityVerification.findBondByFourItems(name, addr, tel, dob);
                out.correctedBondNumber = correctBond;
                if (!String.isBlank(correctBond)) {
                    out.contractSummary = IdentityVerification.buildContractSummaryByBond(correctBond);
                }

                out.nextTemplateKey = 'PT_CONFIRM_CONTRACT';
                out.verified = true;
                out.message = 'verified ok (4-items), wait user confirmation';
                results.add(out);
                continue;
            }

            // 通常ルート（bondあり）
            if (String.isBlank(bond)) {
                setResp(out, 'PT_BOND_ASK', 'bond missing');
                results.add(out);
                continue;
            }

            // bond存在チェック（Apexでは匿名初期化不可のため add を使用）
            List<IdentityVerification.BondCheckRequest> brs = new List<IdentityVerification.BondCheckRequest>();
            IdentityVerification.BondCheckRequest br = new IdentityVerification.BondCheckRequest();
            br.bondNumber = bond;
            brs.add(br);

            List<IdentityVerification.BondCheckResponse> bre = IdentityVerification.checkBondExists(brs);
            Boolean exists = (!bre.isEmpty()) && bre[0].exists;

            if (!exists) {
                bCnt++;
                out.bondAttempts = bCnt;
                if (bCnt >= 2) {
                    out.inFourItemsMode = true;
                    setResp(out, 'PT_ESCALATE_4ITEMS', 'bond not found twice -> escalate');
                } else {
                    setResp(out, 'PT_BOND_RETRY', 'bond not found; retry');
                }
                results.add(out);
                continue;
            }

            // 氏名未入力
            if (String.isBlank(name)) {
                setResp(out, 'PT_NAME_ASK', 'name missing');
                results.add(out);
                continue;
            }

            // bond+name クロスチェック
            IdentityVerification.ContractInfo ci = IdentityVerification.getContractInfoByBondNumber(bond);
            Boolean nameOk = (ci != null) && IdentityVerification.normalize(ci.name).equals(name);
            if (!nameOk) {
                nCnt++;
                out.nameAttempts = nCnt;
                if (nCnt >= 2) {
                    out.inFourItemsMode = true;
                    setResp(out, 'PT_ESCALATE_4ITEMS', 'name mismatch twice -> escalate');
                } else {
                    setResp(out, 'PT_NAME_RETRY', 'name mismatch; retry');
                }
                results.add(out);
                continue;
            }

            // 補助1項目要求
            if (String.isBlank(addr) && String.isBlank(tel) && String.isBlank(dob)) {
                setResp(out, 'PT_EXTRA_ASK', 'ask one of address/tel/birth');
                results.add(out);
                continue;
            }

            // 最終Verify（bondあり）
            Boolean okFinal = IdentityVerificationforAgentforce.verifyIdentityFinal(bond, name, addr, tel, dob);
            if (!okFinal) {
                setVerify(out, false, 'verified NG');
                results.add(out);
                continue;
            }

            out.correctedBondNumber = bond;
            out.contractSummary = IdentityVerification.buildContractSummaryByBond(bond);
            out.nextTemplateKey = 'PT_CONFIRM_CONTRACT';
            out.verified = true;
            out.message = 'verified ok, wait user confirmation';
            results.add(out);
        }

        return results;
    }

    // 共通返却整形
    private static void setResp(Output out, String key, String msg) {
        out.nextTemplateKey = key;
        out.message = msg;
        out.verified = false;
    }

    private static void setVerify(Output out, Boolean ok, String msg) {
        out.nextTemplateKey = ok ? 'PT_VERIFY_OK' : 'PT_VERIFY_RETRY';
        out.message = msg;
        out.verified = ok;
    }
}