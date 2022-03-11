public class AccountCreation 
{
    Public static void createAccount(String name)
    {
        Account a= new Account();
        a.Name = name;
        insert a;
          } 
    public static void flo()
    {
        list<Account> sf = new list<Account>();
        Account a= new Account();
        a.Name = 'name11';
        sf.add(a);
        insert sf;
        
        map<id,list<account>> m = new map<id,list<account>>();
        m.put(sf[0].Id, sf);
        
        system.debug('check map'+ m.keyset());
                system.debug('check val'+ m.values());

        
        
        
     /*   map<integer,string> chk = new map<integer,string>();
        chk.put(1,'jame');
        chk.put(1,'jame1');
        chk.put(3,'jame2');
        chk.put(4,'jame3');
        string nam = chk.get(1);
        system.debug('kl'+nam);
        system.debug('key'+chk.keyset());
        system.debug('key'+chk.values()); */
        
    }
}