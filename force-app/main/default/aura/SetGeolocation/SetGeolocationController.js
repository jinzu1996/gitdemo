({
    myAction : function(component, event, helper) {
        
        var latit;
        var longit;
        
        if(navigator.geoLocation){
            console.log("capability is there");
        }else{
            console.log("No Capability");
        }
        navigator.geolocation.getCurrentPosition(function(position) {
            latit = position.coords.latitude;
            longit = position.coords.longitude; 
            var action = component.get('c.setGeolocation');
            
            action.setParams({
                'evntId': component.get("v.recordId"),
                'lat': latit,
                'lng': longit,
            });
            
            action.setCallback(this,function(response){            
                //var getobjects = response.getReturnValue();
                
                if (response.getReturnValue() == true)
                {
                    alert("Geo Location set successfully");
                    //component.addEventHandler("force:recordChange", component.getReference("c.handleRecordEdit"));
                    //var editRecordEvent = $A.get("e.force:editRecord");
                   // editRecordEvent.setParams({
                    //    "recordId": component.get("v.recordId"),
                    //});
                    
                   // editRecordEvent.fire();
                    
                    $A.get("e.force:closeQuickAction").fire();
                }
                else
                {
                    alert("Geo Location not set");
                }
            });
            
            $A.enqueueAction(action);
            
            
            component.set("v.latitude",latit);
            component.set("v.longitude",longit);
            console.log("The Latitude is:"+ latit);
            console.log("The Latitude is:" +longit);
            console.log(component.get("v.recordId"));            
        });
        
        
    },

    handleRecordEdit : function(component, event, helper) {
        
    }
})