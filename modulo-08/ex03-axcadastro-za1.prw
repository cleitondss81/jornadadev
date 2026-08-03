#include "protheus.ch"

USER FUNCTION STTIP001() 

	PRIVATE cCadastro := "Pets"
	dbSelectArea("ZA1")
	dbSetOrder(1)        
	
	AxCadastro("ZA1","Pets" )
RETURN NIL

/*
PRINTS :

MENU-PETS1.png

TDS-STTIP00.png

TELA-PETS.png

*/
