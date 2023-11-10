/**
 * @description Service layer for CountryLayer logic
 */
public without sharing class NN_CountryLayerService {

    // named credentials can not be used due to lack of HTTPS method (only HTTP is available)
    private static final String ACCESS_KEY = 'a7272c433579885ad6be3efda47401a0';
    private static final String ENDPOINT = 'http://api.countrylayer.com/v2/all?access_key=' + ACCESS_KEY;
    private static final Integer SUCCESS_REST_RESPONSE = 200;
    
    /**
     * @description perform a REST call to CountryLayer service in order to download data.
     * Method is anotated with @Future in order to be able to be called from Scheduled class.
     * After successfull REST call is performed, HNK_Country__c records are updated with new value.
     */
    @Future(callout=true)
    public static void updateCountries() {

        HttpResponse response = performCalloutToCountryLayer();

        if(response.getStatusCode() == SUCCESS_REST_RESPONSE) {            
            List<NN_CountryLayerPayload> payload = (List<NN_CountryLayerPayload>)JSON.deserialize(response.getBody(), List<NN_CountryLayerPayload>.class);
            List<NN_Country__c> countriesToUpdate = mapCountryLayerResponseToCountry(payload);
            Database.upsert(countriesToUpdate, NN_Country__c.Name);
        } else {
            // create custom logging service to log an error
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        }
    }

    /**
     * @description perform REST call to CountryLayer service and return response.
     * @return   return HttpResponse
     */
    private static HttpResponse performCalloutToCountryLayer() {

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        return http.send(request);
    }

    /**
     * @description method map NN_CountryLayerPayload (payload from CountryLayer REST call) to NN_Country__c object.
     * @param  payload list of NN_CountryLayerPayload
     * @return list of NN_Country__c
     */
    private static List<NN_Country__c> mapCountryLayerResponseToCountry(List<NN_CountryLayerPayload> payload) {

        List<NN_Country__c> countries = new List<NN_Country__c>();
        
        for (NN_CountryLayerPayload countryLayer : payload) {

            NN_Country__c country = new NN_Country__c();
            country.NN_Capital__c = countryLayer.capital;
            country.Name = countryLayer.name;
            country.NN_Alpha2Code__c = countryLayer.alpha2Code;
            country.NN_Alpha3code__c = countryLayer.alpha3Code;
            country.NN_Region__c = countryLayer.region;
            country.NN_RegionalBlocs__c = countryLayer.regionalBlocs;

            countries.add(country);
        }

        return countries;
    }

    /**
     * @description Helper class to deserialize response from CountryLayer REST call
     */
    @testvisible
    private class NN_CountryLayerPayload {
        @testvisible private String capital;
        @testvisible private String name;
        @testvisible private String alpha2Code;
        @testvisible private String alpha3Code;
        @testvisible private String region;
        @testvisible private String regionalBlocs;
    }
}