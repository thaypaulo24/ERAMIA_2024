IMPORT $;
IMPORT ML_Core;
//
MyriadPrepData := $.modPrepData.MyriadPrepData;
//
// Torne os dados aleatórios, ordenando os registros pelo número randômico
MyriadPrepDataSort := SORT(MyriadPrepData(wi_id <> 0), rnd);
//
//
// Segregação dos dados - Considerando os primeiros 5.000 registros como amostra de Treinamento
MyriadTrainData := PROJECT(MyriadPrepDataSort[1..5000], $.modPrepData.ML_Prop)
                      :PERSIST('~CLASS::XYZ::ML::MyriadTrain');             // layout sem o campo rnd
//
// Segregação dos dados - Considerando os 2.000 registros seguintes como amostra de Teste
MyriadTestData  := PROJECT(MyriadPrepDataSort[5001..7000], $.modPrepData.ML_Prop)
                      :PERSIST('~CLASS::XYZ::ML::MyriadTest');              // layout sem o campo rnd
//
//
// Conversão Matricial dos campos numéricos
ML_Core.ToField(MyriadTrainData, MyriadTrainDataNF, wifield := wi_id);  // "idfield" não fornecido, assume 1º campo = propertyid
ML_Core.ToField(MyriadTestData,  MyriadTestDataNF,  wifield := wi_id);  // "idfield" não fornecido, assume 1º campo = propertyid
//
//
EXPORT modSegConvData := MODULE
	EXPORT MyriadIndTrainDataNF := MyriadTrainDataNF(number < 10);    // excluindo o campo propertyid
//
	EXPORT MyriadDepTrainDataNF := PROJECT(MyriadTrainDataNF(number = 10), TRANSFORM(RECORDOF(LEFT),
                                                                            SELF.number := 1,
                                                                            SELF := LEFT));
//
	EXPORT MyriadIndTestDataNF  := MyriadTestDataNF(number < 10);      // excluindo o campo propertyid
//
	EXPORT MyriadDepTestDataNF  := PROJECT(MyriadTestDataNF(number = 10), TRANSFORM(RECORDOF(LEFT), 
                                                                            SELF.number := 1,
                                                                            SELF := LEFT));
END;
//