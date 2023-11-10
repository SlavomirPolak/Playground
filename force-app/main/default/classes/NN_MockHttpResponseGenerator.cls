/**
 * @description Mock HttpRepsonse for testing purpose
 */
@isTest
global class NN_MockHttpResponseGenerator implements HttpCalloutMock {

    Integer responseCode;

    public NN_MockHttpResponseGenerator(Integer responseCode) {
        this.responseCode = responseCode;
    }
    
    /**
     * @description prepare and return mocked response for testing purpose
     * @param  req HTTPRequest
     * @return     HTTPResponse
     */
    global HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(this.responseCode);

        if (this.responseCode == 200) {
            List<NN_CountryLayerService.NN_CountryLayerPayload> mockPayload = NN_TestDataFactory.preparePayload().values();
            res.setBody(JSON.serialize(mockPayload));            
        } else {
            res.setBody('');
        }

        return res;
    }
}