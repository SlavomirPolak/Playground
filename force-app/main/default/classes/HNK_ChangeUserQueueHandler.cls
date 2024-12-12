public without sharing class HNK_ChangeUserQueueHandler {
    
    @AuraEnabled(Cacheable=true)
    public static List<Group> getQueues(){
        
        List<Group> groups = new List<Group>();
        String userRoleId = UserInfo.getUserRoleId();

        if (String.isBlank(userRoleId)) {
            throw new HNK_ChangeUserQueueHandlerException();
        }

        groups = [
            SELECT Id, Name
            FROM Group
            WHERE Type = 'Regular'
            WITH SECURITY_ENFORCED
            ORDER BY Name
        ];
        return groups;
    }

    @AuraEnabled(Cacheable=true)
    public static List<User> getUsersFromGroup(String idQueueSelected) {

        String userRoleId = UserInfo.getUserRoleId();

        List<User> groupMembers = [
            SELECT Id, FirstName, LastName, Username
            FROM User
            WHERE
                (UserRole.ParentRoleId = :userRoleId
                OR Id = :UserInfo.getUserId())
                AND Id IN (
                    SELECT UserOrGroupId
                    FROM GroupMember
                    WHERE GroupId = :idQueueSelected
                )
            WITH SECURITY_ENFORCED
            ORDER BY LastName, FirstName
        ];

        return groupMembers;
    }

    @AuraEnabled(Cacheable=true)
    public static List<User> getAllUsers() {
        String userRoleId = UserInfo.getUserRoleId();

        if (String.isBlank(userRoleId)) {
            throw new HNK_ChangeUserQueueHandlerException();
        }

        return [
            SELECT Username, Id, FirstName, LastName
            FROM User
            WHERE
                (UserRole.ParentRoleId = :userRoleId
                OR Id = :UserInfo.getUserId())
                AND IsActive = TRUE
            WITH SECURITY_ENFORCED
            ORDER BY LastName, FirstName
        ];
    }

    @AuraEnabled
    public static Boolean updateGroup(List<String> users, String grId){

        if (users == null || String.isBlank(grId)) {
            throw new HNK_ChangeUserQueueHandlerException();
        }
        
        Map<Id, User> idVSGroupMember = new Map<Id, User>();
        for (User us : [
            SELECT Id, Name
            FROM User
            WHERE Id IN (SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :grId)
            WITH SECURITY_ENFORCED
        ]) {
            idVSGroupMember.put(us.Id, us);
        }

        List<GroupMember> membersToAdd = new List<GroupMember>();
        for (String idapp : users) {
            if (idVSGroupMember.containsKey(idapp)) {
                idVSGroupMember.remove(idapp);
                continue;
            }
            membersToAdd.add(new GroupMember(groupId = grId, UserOrGroupId = idApp));
        }
        List<GroupMember> membersToErease = new List<GroupMember>();
        if (!idVSGroupMember.isEmpty()) {
            membersToErease = [
                SELECT Id
                FROM GroupMember
                WHERE GroupId = :grId AND UserOrGroupId IN :idVSGroupMember.keySet()
                WITH SECURITY_ENFORCED
            ];
        } else if (users.isEmpty()) {
            membersToErease = [
                SELECT Id
                FROM GroupMember
                WHERE GroupId = :grId
                WITH SECURITY_ENFORCED
            ];
        }

        if (GroupMember.SObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).isDeletable()) {
            delete membersToErease;
        } else {
            throw new HNK_ChangeUserQueueHandlerException();
        }

        System.debug('before Update');

        SObjectAccessDecision securityInsertDecision = Security.stripInaccessible(AccessType.CREATABLE, membersToAdd);

        insert securityInsertDecision.getRecords();

        System.debug('after Update');

        return true;
    }

    public class HNK_ChangeUserQueueHandlerException extends Exception {

    }
}