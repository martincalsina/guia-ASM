#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "Memoria.h"

int main() {
	/* Acá pueden realizar sus propias pruebas */
	char* str = "Omega 4";
	strClone(str);
	return 0;
}
