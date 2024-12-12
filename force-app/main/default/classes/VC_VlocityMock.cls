global with sharing class VC_VlocityMock implements omnistudio.VlocityOpenInterface  {
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
			
        Boolean result = true;

        String str = '[{"Subject":"Billing status","CaseNumber":"00001027"},{"Subject":"Billing status","CaseNumber":"00001028"},{"Subject":"Cannot track our order","CaseNumber":"00001026"},{"Subject":"Shipment on hold update request","CaseNumber":"00001029"},{"Subject":"Cancel Shipment","CaseNumber":"00001049"}]';

        outMap.put('case', str);

        return result;
    }
}