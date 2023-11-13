/**
 * @description Service layer for CountryLayer logic
 */
public without sharing class NN_CountryLayerService {

    // named credentials can not be used due to lack of HTTPS method (only HTTP is available)
    private static final String ACCESS_KEY = 'a7272c433579885ad6be3efda47401a0';
    private static final String ENDPOINT = 'http://api.countrylayer.com/v2/all?access_key=' + ACCESS_KEY;
    private static final Integer SUCCESS_REST_RESPONSE = 200;

    @TestVisible
    private static final String LOG_CLASS_NAME = 'NN_CountryLayerService';
    
    /**
     * @description perform a REST call to CountryLayer service in order to download data.
     * Method is anotated with @Future in order to be able to be called from Scheduled class.
     * After successfull REST call is performed, HNK_Country__c records are updated with new value.
     */
    @Future(callout=true)
    public static void updateCountries() {

        HttpResponse response = performCalloutToCountryLayer();

        if (response.getStatusCode() == SUCCESS_REST_RESPONSE) {
            List<NN_CountryLayerPayload> payload = (List<NN_CountryLayerPayload>)JSON.deserialize(response.getBody(), List<NN_CountryLayerPayload>.class);
            Map<String, NN_Country__c> countriesByCountryName = mapCountryLayerResponseToCountry(payload);
            List<NN_Country__c> countriesToUpdate = processCountries(countriesByCountryName);
            
            Database.UpsertResult[] upsertResults = Database.upsert(countriesToUpdate, NN_Country__c.Name);
            NN_UtilityClass.processUpsertResult(LOG_CLASS_NAME + '.updateCountries', upsertResults);
        } else {
            Database.insert(NN_UtilityClass.createLog(LOG_CLASS_NAME + '.updateCountries', 'An error occured during an API call. ' + response.getStatus()));
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
     * @description compare incoming Countries and compares them with already existing counterparts. If there are changes on listed fields, Country can be updated.
     * Listed fields: Name, NN_Alpha2Code__c, NN_Alpha3code__c, NN_Capital__c, NN_Region__c, NN_RegionalBlocs__c
     * @param  countriesByCountryName incoming Countries in map: key: Name, value: NN_Country__c
     * @return                        return list of countries that can be upserted
     */
    private static List<NN_Country__c> processCountries(Map<String, NN_Country__c> countriesByCountryName) {

        List<NN_Country__c> countriesToUpsert = new List<NN_Country__c>();
        List<NN_Country__c> currentCountries = NN_CountrySelector.selectCountryByName(countriesByCountryName.keySet());
        Map<String, NN_Country__c> currentCountriesByCountryName = new Map<String, NN_Country__c>();

        for (NN_Country__c currentCountry : currentCountries) {
            currentCountriesByCountryName.put(currentCountry.Name, currentCountry);
        }

        for (NN_Country__c incomingCountry : countriesByCountryName.values()) {

            if (!compareFields(currentCountriesByCountryName.get(incomingCountry.Name), incomingCountry)) {
                countriesToUpsert.add(incomingCountry);
            }
        }

        return countriesToUpsert;
    }

    /**
     * @description method map NN_CountryLayerPayload (payload from CountryLayer REST call) to NN_Country__c object.
     * @param  payload list of NN_CountryLayerPayload
     * @return list of NN_Country__c
     */
    private static Map<String, NN_Country__c> mapCountryLayerResponseToCountry(List<NN_CountryLayerPayload> payload) {

        Map<String, NN_Country__c> countriesByCountryName = new Map<String, NN_Country__c>();
        
        for (NN_CountryLayerPayload countryLayer : payload) {

            NN_Country__c country = new NN_Country__c();
            country.NN_Capital__c = countryLayer.capital;
            country.Name = countryLayer.name;
            country.NN_Alpha2Code__c = countryLayer.alpha2Code;
            country.NN_Alpha3code__c = countryLayer.alpha3Code;
            country.NN_Region__c = countryLayer.region;
            country.NN_RegionalBlocs__c = countryLayer.regionalBlocs;

            countriesByCountryName.put(country.Name, country);
        }

        return countriesByCountryName;
    }

    /**
     * @description perform equality on fields of NN_Country__c object
     * @param  countryA first NN_Country__c object
     * @param  countryB second NN_Country__c object
     * @return          return True if criteria are met
     */
    public static Boolean compareFields(NN_Country__c countryA, NN_Country__c countryB) {
        
        return (countryA != null && countryB != null) && (countryA.Name == countryB.Name &&
        countryA.NN_Alpha2Code__c == countryB.NN_Alpha2Code__c &&
        countryA.NN_Alpha3code__c == countryB.NN_Alpha3code__c &&
        countryA.NN_Capital__c == countryB.NN_Capital__c &&
        countryA.NN_Region__c == countryB.NN_Region__c &&
        countryA.NN_RegionalBlocs__c == countryB.NN_RegionalBlocs__c);
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