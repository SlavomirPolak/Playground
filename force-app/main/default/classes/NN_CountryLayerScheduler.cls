/**
 * @description Scheduler for CountryLayer service
 */
global class NN_CountryLayerScheduler implements Schedulable {
    
    /**
     * @description execute method
     * @param sc SchedulableContext
     */
    global void execute(System.SchedulableContext sc) {
        NN_CountryLayerService.updateCountries();
    }
}