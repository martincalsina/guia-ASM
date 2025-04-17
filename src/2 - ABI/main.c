#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "ABI.h"

int main() {
	/* Acá pueden realizar sus propias pruebas */
	assert(alternate_sum_4_using_c(8, 2, 5, 1) == 10);

	assert(alternate_sum_8(8, 2, 5, 1, 0, 0, 4, 2) == 12);

	assert(alternate_sum_8_using_sum_4(8, 2, 5, 1, 0, 0, 4, 2) == 12);

	assert(alternate_sum_4_using_c_alternative(8, 2, 5, 1) == 6);
	return 0;
}
