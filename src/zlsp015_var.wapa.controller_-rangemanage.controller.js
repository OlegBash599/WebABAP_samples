sap.ui.define([                                                                                                                                                                                                                                                
	"sap/ui/core/mvc/Controller",                                                                                                                                                                                                                                 
	"sap/ui/core/routing/History",                                                                                                                                                                                                                                
	"zlsp015_varid/controller/ODataFeed",                                                                                                                                                                                                                         
	"zlsp015_varid/model/formatter"                                                                                                                                                                                                                               
], function(Controller, History, ODataFeed,formatter) {                                                                                                                                                                                                        
	"use strict";                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                               
	return Controller.extend("zlsp015_varid.controller.RangeManage", {                                                                                                                                                                                            
                                                                                                                                                                                                                                                               
		ODataFeed: ODataFeed,                                                                                                                                                                                                                                        
		formatter: formatter,                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                               
		/**                                                                                                                                                                                                                                                          
		 * Called when a controller is instantiated and its View controls (if available) are already created.                                                                                                                                                        
		 * Can be used to modify the View before it is displayed, to bind event handlers and do other one-time initialization.                                                                                                                                       
		 * @memberOf zlsp015_varid.view.RangeManage                                                                                                                                                                                                                  
		 */                                                                                                                                                                                                                                                          
		onInit: function() {                                                                                                                                                                                                                                         
			sap.m.MessageToast.show("Hi from RangeManage");                                                                                                                                                                                                             
			this._Router = sap.ui.core.UIComponent.getRouterFor(this);                                                                                                                                                                                                  
			this._Router.getRoute("rangeVar").attachPatternMatched(this._onPatternMatched, this);                                                                                                                                                                       
			this._abap_true = 'X';                                                                                                                                                                                                                                      
			this._abap_false = ' ';                                                                                                                                                                                                                                     
		}                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                               
		/**                                                                                                                                                                                                                                                          
		 * Similar to onAfterRendering, but this hook is invoked before the controller's View is re-rendered                                                                                                                                                         
		 * (NOT before the first rendering! onInit() is used for that one!).                                                                                                                                                                                         
		 * @memberOf zlsp015_varid.view.RangeManage                                                                                                                                                                                                                  
		 */                                                                                                                                                                                                                                                          
		//	onBeforeRendering: function() {                                                                                                                                                                                                                           
		//                                                                                                                                                                                                                                                           
		//	},                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                               
		/**                                                                                                                                                                                                                                                          
		 * Called when the View has been rendered (so its HTML is part of the document). Post-rendering manipulations of the HTML could be done here.                                                                                                                
		 * This hook is the same one that SAPUI5 controls get after being rendered.                                                                                                                                                                                  
		 * @memberOf zlsp015_varid.view.RangeManage                                                                                                                                                                                                                  
		 */                                                                                                                                                                                                                                                          
		//	onAfterRendering: function() {                                                                                                                                                                                                                            
		//                                                                                                                                                                                                                                                           
		//	},                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                               
		/**                                                                                                                                                                                                                                                          
		 * Called when the Controller is destroyed. Use this one to free resources and finalize activities.                                                                                                                                                          
		 * @memberOf zlsp015_varid.view.RangeManage                                                                                                                                                                                                                  
		 */                                                                                                                                                                                                                                                          
		//	onExit: function() {                                                                                                                                                                                                                                      
		//                                                                                                                                                                                                                                                           
		//	}                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                               
		,                                                                                                                                                                                                                                                            
		onNavBack: function() {                                                                                                                                                                                                                                      
			var sPreviousHash = History.getInstance().getPreviousHash();                                                                                                                                                                                                
                                                                                                                                                                                                                                                               
			if (sPreviousHash !== undefined) {                                                                                                                                                                                                                          
				history.go(-1);                                                                                                                                                                                                                                            
			} else {                                                                                                                                                                                                                                                    
				this.getRouter().navTo("worklist", {}, true);                                                                                                                                                                                                              
			}                                                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                               
		,                                                                                                                                                                                                                                                            
		_onPatternMatched: function(oEvent) {                                                                                                                                                                                                                        
			// alert("Bad Alert");                                                                                                                                                                                                                                      
			// console.log("Bad Console Log");                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                               
			var varName = oEvent.getParameter("arguments").VarName;                                                                                                                                                                                                     
			// console.log(`Bad Console Log: ${varName}`);                                                                                                                                                                                                              
			this._readRangeData(varName);                                                                                                                                                                                                                               
		}                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                               
		,                                                                                                                                                                                                                                                            
		_readRangeData: function(sVarName) {                                                                                                                                                                                                                         
			var oRangeService = {};                                                                                                                                                                                                                                     
			oRangeService.serviceUrl = "/sap/opu/odata/SAP/ZLS015_SRV";                                                                                                                                                                                                 
			oRangeService.entityPath = "/VariableIDSet('" + sVarName.toString() + "')" + "?$expand=VariableValueSet";                                                                                                                                                   
                                                                                                                                                                                                                                                               
			//	this.ODataFeed.getODataModel(oSwitchService).then(                                                                                                                                                                                                       
			this.ODataFeed.getJsonModelEntity(oRangeService).then(                                                                                                                                                                                                      
				this._RangeServiceOk.bind(this),                                                                                                                                                                                                                           
				this._RangeServiceError.bind(this)                                                                                                                                                                                                                         
			);                                                                                                                                                                                                                                                          
		}                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                               
		,                                                                                                                                                                                                                                                            
		_RangeServiceOk: function(oModelJson) {                                                                                                                                                                                                                      
			//	var oModelJson = new sap.ui.model.json.JSONModel();                                                                                                                                                                                                      
			//	oModelJson.setData(OData);                                                                                                                                                                                                                               
			this.getView().setModel(oModelJson, "RangeData");                                                                                                                                                                                                           
		}                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                               
		,                                                                                                                                                                                                                                                            
		_RangeServiceError: function(oError) {                                                                                                                                                                                                                       
			sap.m.MessageToast.show("...не удалось прочитать данные по переменной для набора значений...");                                                                                                                                                             
		}                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                               
		,                                                                                                                                                                                                                                                            
		onAddRow: function(oEvent) {                                                                                                                                                                                                                                 
			var oTable = this.byId("TableVarVal");                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                               
			var NewRow = new sap.ui.table.Row();                                                                                                                                                                                                                        
			oTable.addRow(NewRow);                                                                                                                                                                                                                                      
		}                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                               
		,                                                                                                                                                                                                                                                            
		onSaveModel: function(oEvent) {                                                                                                                                                                                                                              
			var oModelJson = this.getView().getModel("RangeData");                                                                                                                                                                                                      
			var oRangeService = {};                                                                                                                                                                                                                                     
			oRangeService.serviceUrl = "/sap/opu/odata/SAP/ZLS015_SRV";                                                                                                                                                                                                 
			oRangeService.entityPath = "/VariableIDSet";                                                                                                                                                                                                                
			oRangeService.Entry = oModelJson.getData();                                                                                                                                                                                                                 
			//	if(oSwitchService.Entry.hasOwnProperty("Name")){                                                                                                                                                                                                         
			//		oSwitchService.Entry.Name = "";                                                                                                                                                                                                                         
			//	}                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                               
			this.ODataFeed.createRequest(oRangeService).then(                                                                                                                                                                                                           
				this._updateOk.bind(this),                                                                                                                                                                                                                                 
				this._updateError.bind(this)                                                                                                                                                                                                                               
			);                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                               
		}                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                               
		,                                                                                                                                                                                                                                                            
		_updateOk: function() {                                                                                                                                                                                                                                      
			sap.m.MessageToast.show("...Обновление успешно...");                                                                                                                                                                                                        
			this.onNavBack();                                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                               
		,                                                                                                                                                                                                                                                            
		_updateError: function() {                                                                                                                                                                                                                                   
			sap.m.MessageToast.show("...Обновление c ошибкой...");                                                                                                                                                                                                      
			this.onNavBack();                                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                               
	});                                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                               
});                                                                                                                                                                                                                                                            