public class fromJSON 
{
    public String source_tag;	//
	public String data_time;	//
	public String transaction_id;	//
	public String fullname;	//
	public String mobile_number;	//
	public String status;	//
	public String payment_status;	//
	public String gstn;	//
	public String address;	//
	public String amount;	//
	public String product_info;	//
	public cls_easebuzz easebuzz;
	class cls_easebuzz {
		public String key;	//
		public String txnid;	//
		public String amount;	//
		public String productinfo;	//
		public String firstname;	//
		public String phone;	//
		public String email;	//
	}
	public static fromJSON parse(String json1)
    {
		return (fromJSON) System.JSON.deserialize(json1, fromJSON.class);
	}
   /* static testMethod void testParse() {
		String json=		'{'+
		'   "source_tag":"",'+
		'   "data_time":"",'+
		'   "transaction_id":"",'+
		'   "fullname":"",'+
		'   "mobile_number":"",'+
		'   "status":"",'+
		'   "payment_status":"",'+
		'   "gstn":"",'+
		'   "address":"",'+
		'   "amount":"",'+
		'   "product_info":"",'+
		'   "easebuzz":{'+
		'      "key":"",'+
		'      "txnid":"",'+
		'      "amount":"",'+
		'      "productinfo":"",'+
		'      "firstname":"",'+
		'      "phone":"",'+
		'      "email":""'+
		'   }'+
		'}';
		fromJSON obj = parse(json);
		System.assert(obj != null);
	} */

}