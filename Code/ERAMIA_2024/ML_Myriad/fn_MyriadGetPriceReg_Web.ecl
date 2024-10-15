IMPORT $,STD,Visualizer;
IMPORT ML_Core;
IMPORT LearningTrees AS LT;
//
// Função de predição de preços de imóveis
EXPORT fn_MyriadGetPriceReg_Web(zip,
                                assess_val,
                                year_acq,
                                land_sq_ft,
                                living_sq_ft,
                                bedrooms,
                                full_baths,
                                half_baths,
                                year_built,
                                // state_code = 0) := FUNCTION
                                STRING2 _state_01 = 'XX',
                                STRING2 _state_02 = 'YY',
                                STRING2 _state_03 = 'ZZ') := FUNCTION
//
WUID := WORKUNIT; // obter o Id da WorkUnit
//
// Transformação dos parâmetros de entrada no formato de ML data frame				
  MyriadInSet := [zip, assess_val, year_acq, land_sq_ft, living_sq_ft, bedrooms, full_baths, half_baths, year_built];
  MyriadInDS  := DATASET(MyriadInSet, {REAL8 MyriadInValue});
//
	ML_Core.Types.NumericField PrepDataReg01(RECORDOF(MyriadInDS) Le, INTEGER cnt01) := TRANSFORM
		// SELF.wi     := state_code,
    SELF.wi     := CASE(STD.Str.ToUpperCase(_state_01), 'AE' => 1,'WY' => 2,'TN' => 3,'MI' => 4,'RI' => 5,'SC' => 6,
                                                        'VA' => 7,'NH' => 8,'AP' => 9,'NM' => 10,'IL' => 11,'KS' => 12,
                                                        'ME' => 13,'AL' => 14,'WA' => 15,'NY' => 16,'MO' => 17,'PA' => 18,
                                                        'HI' => 19,'GU' => 20,'VT' => 21,'CT' => 22,'NC' => 23,'OR' => 24,
                                                        'IA' => 25,'DE' => 26,'VI' => 27,'ID' => 28,'MT' => 29,'AR' => 30,
                                                        'MS' => 31,'UT' => 32,'NE' => 33,'IN' => 34,'GA' => 35,'WV' => 36,
                                                        'NJ' => 37,'LA' => 38,'WI' => 39,'AK' => 40,'CA' => 41,'NV' => 42,
                                                        'FL' => 43,'MA' => 44,'CO' => 45,'AZ' => 46,'SD' => 47,'DC' => 48,
                                                        'KY' => 49,'MP' => 50,'ND' => 51,'AS' => 52,'TX' => 53,'PR' => 54,
                                                        'MD' => 55,'OH' => 56,'MN' => 57,'OK' => 58,'AA' => 59,0),
		SELF.id	    := 1,
		SELF.number := cnt01,
		SELF.value  := Le.MyriadInValue;
	END;
	MyriadNewIndDataReg01 := PROJECT(MyriadInDS, PrepDataReg01(LEFT, COUNTER));
//
	ML_Core.Types.NumericField PrepDataReg02(RECORDOF(MyriadInDS) Le, INTEGER cnt02) := TRANSFORM
		// SELF.wi     := state_code,
    SELF.wi     := CASE(STD.Str.ToUpperCase(_state_02), 'AE' => 1,'WY' => 2,'TN' => 3,'MI' => 4,'RI' => 5,'SC' => 6,
                                                        'VA' => 7,'NH' => 8,'AP' => 9,'NM' => 10,'IL' => 11,'KS' => 12,
                                                        'ME' => 13,'AL' => 14,'WA' => 15,'NY' => 16,'MO' => 17,'PA' => 18,
                                                        'HI' => 19,'GU' => 20,'VT' => 21,'CT' => 22,'NC' => 23,'OR' => 24,
                                                        'IA' => 25,'DE' => 26,'VI' => 27,'ID' => 28,'MT' => 29,'AR' => 30,
                                                        'MS' => 31,'UT' => 32,'NE' => 33,'IN' => 34,'GA' => 35,'WV' => 36,
                                                        'NJ' => 37,'LA' => 38,'WI' => 39,'AK' => 40,'CA' => 41,'NV' => 42,
                                                        'FL' => 43,'MA' => 44,'CO' => 45,'AZ' => 46,'SD' => 47,'DC' => 48,
                                                        'KY' => 49,'MP' => 50,'ND' => 51,'AS' => 52,'TX' => 53,'PR' => 54,
                                                        'MD' => 55,'OH' => 56,'MN' => 57,'OK' => 58,'AA' => 59,0),
		SELF.id	    := 1,
		SELF.number := cnt02,
		SELF.value  := Le.MyriadInValue;
	END;
	MyriadNewIndDataReg02 := PROJECT(MyriadInDS, PrepDataReg02(LEFT, COUNTER));
//
	ML_Core.Types.NumericField PrepDataReg03(RECORDOF(MyriadInDS) Le, INTEGER cnt03) := TRANSFORM
		// SELF.wi     := state_code,
    SELF.wi     := CASE(STD.Str.ToUpperCase(_state_03), 'AE' => 1,'WY' => 2,'TN' => 3,'MI' => 4,'RI' => 5,'SC' => 6,
                                                        'VA' => 7,'NH' => 8,'AP' => 9,'NM' => 10,'IL' => 11,'KS' => 12,
                                                        'ME' => 13,'AL' => 14,'WA' => 15,'NY' => 16,'MO' => 17,'PA' => 18,
                                                        'HI' => 19,'GU' => 20,'VT' => 21,'CT' => 22,'NC' => 23,'OR' => 24,
                                                        'IA' => 25,'DE' => 26,'VI' => 27,'ID' => 28,'MT' => 29,'AR' => 30,
                                                        'MS' => 31,'UT' => 32,'NE' => 33,'IN' => 34,'GA' => 35,'WV' => 36,
                                                        'NJ' => 37,'LA' => 38,'WI' => 39,'AK' => 40,'CA' => 41,'NV' => 42,
                                                        'FL' => 43,'MA' => 44,'CO' => 45,'AZ' => 46,'SD' => 47,'DC' => 48,
                                                        'KY' => 49,'MP' => 50,'ND' => 51,'AS' => 52,'TX' => 53,'PR' => 54,
                                                        'MD' => 55,'OH' => 56,'MN' => 57,'OK' => 58,'AA' => 59,0),
		SELF.id	    := 1,
		SELF.number := cnt03,
		SELF.value  := Le.MyriadInValue;
	END;
	MyriadNewIndDataReg03 := PROJECT(MyriadInDS, PrepDataReg03(LEFT, COUNTER));
//
//
// Predição e retorno do valor do imóvel consultado - State 01
	MyriadModel01       := DATASET('~CLASS::XYZ::ML::MyriadModelR',ML_Core.Types.Layout_Model2,FLAT,PRELOAD);
	MyriadLearner01     := LT.RegressionForest(10,,10,[1]);
	MyriadPredictDeps01 := MyriadLearner01.Predict(MyriadModel01, MyriadNewIndDataReg01);
//
// Predição e retorno do valor do imóvel consultado - State 02
	MyriadModel02       := DATASET('~CLASS::XYZ::ML::MyriadModelR',ML_Core.Types.Layout_Model2,FLAT,PRELOAD);
	MyriadLearner02     := LT.RegressionForest(10,,10,[1]);
	MyriadPredictDeps02 := MyriadLearner02.Predict(MyriadModel02, MyriadNewIndDataReg02);
//
// Predição e retorno do valor do imóvel consultado - State 03
	MyriadModel03       := DATASET('~CLASS::XYZ::ML::MyriadModelR',ML_Core.Types.Layout_Model2,FLAT,PRELOAD);
	MyriadLearner03     := LT.RegressionForest(10,,10,[1]);
	MyriadPredictDeps03 := MyriadLearner03.Predict(MyriadModel03, MyriadNewIndDataReg03);
//
//
Action01a := OUTPUT(MyriadPredictDeps01,{preco:=ROUND(value)}, NAMED('Preco_Imovel_01'));
Action01b := OUTPUT(MyriadPredictDeps02,{preco:=ROUND(value)}, NAMED('Preco_Imovel_02'));
Action01c := OUTPUT(MyriadPredictDeps03,{preco:=ROUND(value)}, NAMED('Preco_Imovel_03'));
//
Action02a := OUTPUT(MyriadPredictDeps01,{states:=_state_01, preco:=ROUND(value)}, NAMED('Choropleth_USStates'),EXTEND);
Action02b := OUTPUT(MyriadPredictDeps02,{states:=_state_02, preco:=ROUND(value)}, NAMED('Choropleth_USStates'),EXTEND);
Action02c := OUTPUT(MyriadPredictDeps03,{states:=_state_03, preco:=ROUND(value)}, NAMED('Choropleth_USStates'),EXTEND);
//
Action03  := Visualizer.Choropleth.USStates('Myriad',, 'Choropleth_USStates');
Action04  := OUTPUT(WUID, Named('WUID'));
//
//
	// RETURN OUTPUT(MyriadPredictDeps,{preco:=ROUND(value)});
  RETURN SEQUENTIAL(Action01a,Action01b,Action01c,
                    Action02a,Action02b,Action02c,
                    Action03,
                    Action04);
END;
//