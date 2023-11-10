/**
 * @description Test for NN_CountryLayerScheduler
 * Test is without IsParallel=true -> In parallel Apex tests, DML operations aren't permitted on this type of object: CronJobDetail
 */
@IsTest
public with sharing class NN_CountryLayerSchedulerTest {

    private static final String JOB_NAME = 'NN_CountryUpdateTEST';
    
    @IsTest
    public static void testScheduler() {
        
        Test.setMock(HttpCalloutMock.class, new NN_MockHttpResponseGenerator(200));
        Datetime currentDatePlusHour = Datetime.now().addHours(1);
		String cron = currentDatePlusHour.format('s m H d M \'?\' yyyy');
        NN_CountryLayerScheduler schedulableClass = new NN_CountryLayerScheduler();

        Test.startTest();
        System.schedule(JOB_NAME, cron, new NN_CountryLayerScheduler());
        Test.stopTest();

        CronTrigger ct = [SELECT Id, CronExpression, CronJobDetail.Name, TimesTriggered, NextFireTime,CronJobDetailId
                    FROM CronTrigger WHERE CronJobDetail.Name = :JOB_NAME];

        System.assertEquals(cron, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(currentDatePlusHour, ct.NextFireTime);
   }
}