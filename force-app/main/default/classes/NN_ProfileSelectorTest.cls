/**
 * @description Test for NN_ProfileSelector
 */
@IsTest(IsParallel=true)
public with sharing class NN_ProfileSelectorTest {

    private static final String ADMIN_PROFILE_NAME = 'System Administrator';
    
    @IsTest
    static void selectProfileIdByNameAdminProfile() {

        Test.startTest();
        List<Profile> selectedProfiles = NN_ProfileSelector.selectProfileIdByName(ADMIN_PROFILE_NAME);
        Test.stopTest();

        System.assertEquals(1, selectedProfiles.size());
    }

    @IsTest
    static void selectProfileIdByNameNonExistingProfile() {

        Test.startTest();
        List<Profile> selectedProfiles = NN_ProfileSelector.selectProfileIdByName('qwerty_testNon_existing');
        Test.stopTest();

        System.assertEquals(0, selectedProfiles.size());
    }
}