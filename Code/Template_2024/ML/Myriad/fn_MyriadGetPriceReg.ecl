IMPORT $,STD,Visualizer;
IMPORT ML_Core;
IMPORT LearningTrees AS LT;
//
// Função de predição de preços de imóveis
EXPORT fn_MyriadGetPriceReg(zip,
                            assess_val,
                            year_acq,
                            land_sq_ft,
                            living_sq_ft,
                            bedrooms,
                            full_baths,
                            half_baths,
                            year_built,
                            // state_code = 0) := FUNCTION
                            STRING2 _state_ = 'XX') := FUNCTION
//
WUID := WORKUNIT; // obter o Id da WorkUnit
//
// Transformação dos parâmetros de entrada no formato de ML data frame				
  MyriadInSet := [zip, assess_val, year_acq, land_sq_ft, living_sq_ft, bedrooms, full_baths, half_baths, year_built];
  MyriadInDS  := DATASET(MyriadInSet, {REAL8 MyriadInValue});
	ML_Core.Types.NumericField PrepDataReg(RECORDOF(MyriadInDS) Le, INTEGER cnt) := TRANSFORM
		// SELF.wi     := state_code,
    SELF.wi     := CASE(STD.Str.ToUpperCase(_state_), 'AE' => 1,'WY' => 2,'TN' => 3,'MI' => 4,'RI' => 5,'SC' => 6,
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
		SELF.number := cnt,
		SELF.value  := Le.MyriadInValue;
	END;
	MyriadNewIndDataReg := PROJECT(MyriadInDS, PrepDataReg(LEFT, COUNTER));
//
// Predição e retorno do valor do imóvel consultado
	MyriadModelR      := DATASET('~CLASS::XYZ::ML::MyriadModelR',ML_Core.Types.Layout_Model2,FLAT,PRELOAD);
	MyriadLearnerR    := LT.RegressionForest(10,,10,[1]);
	MyriadPredictDeps := MyriadLearnerR.Predict(MyriadModelR, MyriadNewIndDataReg);
//
//
Action01 := OUTPUT(MyriadPredictDeps,{preco:=ROUND(value)}, NAMED('Preco_Imovel'));
Action02 := OUTPUT(MyriadPredictDeps,{_state_, preco:=ROUND(value)}, NAMED('Choropleth_USStates'));
Action03 := Visualizer.Choropleth.USStates('Myriad',, 'Choropleth_USStates');
Action04 := OUTPUT(WUID, Named('WUID'));
//
//
	// RETURN OUTPUT(MyriadPredictDeps,{preco:=ROUND(value)});
  RETURN SEQUENTIAL(Action01,PARALLEL(Action02,Action03),Action04);
END;
//