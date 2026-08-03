// X3_VALID = "U_VALCLI001()"
USER FUNCTION VALCLI001()
	IF !ExistCpo("SA1", xFilial("SA1")+M->ZA1_CLIENT+M->ZA1_LOJA, 1)
		MsgAlert("Cliente não cadastrado na SA1!", "Atenção")
		RETURN .F.
	ENDIF
RETURN .T.


/*

PRINT :

VALCLI001.png


*/
