public with sharing class IdentityVerificationInvokeVerify {
    public class VerifyRequest {
        @InvocableVariable public String bondNumber;
        @InvocableVariable public String name;
        @InvocableVariable public String address;
        @InvocableVariable public String telNumber;
        @InvocableVariable public String birth;
    }
    public class VerifyResponse {
        @InvocableVariable public Boolean verified;
        @InvocableVariable public String message;
    }

    @InvocableMethod(label='本人確認（最終判定）')
    public static List<VerifyResponse> verify(List<VerifyRequest> requests) {
        List<VerifyResponse> results = new List<VerifyResponse>();
        for (VerifyRequest req : requests) {
            Boolean ok = IdentityVerification.verifyIdentityFinal(
                req.bondNumber, req.name, req.address, req.telNumber, req.birth
            );
            VerifyResponse vr = new VerifyResponse();
            vr.verified = ok;
            vr.message = ok ? 'Verified' : 'Not verified';
            results.add(vr);
        }
        return results;
    }
}