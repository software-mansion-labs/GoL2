%lang starknet

from starkware.cairo.common.cairo_builtins import (HashBuiltin,
    BitwiseBuiltin)
from starkware.cairo.common.alloc import alloc

from contracts.utils.life_rules import get_adjecent, evaluate_rounds

@external
func test_get_adjecent{
        range_check_ptr
    }():
    let (L, R, U, D, LU, RU, LD, RD) = get_adjecent(16)
    assert L = 15
    assert R = 17
    assert U = 1
    assert D = 31
    assert LU = 0
    assert RU = 2
    assert LD = 30
    assert RD = 32
    return ()
end

@external
func test_get_adjecent_wrapped_UL{
        range_check_ptr
    }():
    let (L, R, U, D, LU, RU, LD, RD) = get_adjecent(0)
    assert L = 14
    assert R = 1
    assert U = 210
    assert D = 15
    assert LU = 224
    assert RU = 211
    assert LD = 29
    assert RD = 16
    return ()
end

@external
func test_get_adjecent_wrapped_DL{
        range_check_ptr
    }():
    let (L, R, U, D, LU, RU, LD, RD) = get_adjecent(210)
    assert L = 224
    assert R = 211
    assert U = 195
    assert D = 0
    assert LU = 209
    assert RU = 196
    assert LD = 14
    assert RD = 1
    return ()
end

@external
func test_get_adjecent_wrapped_UR{
        range_check_ptr
    }():
    let (L, R, U, D, LU, RU, LD, RD) = get_adjecent(14)
    assert L = 13
    assert R = 0
    assert U = 224
    assert D = 29
    assert LU = 223
    assert RU = 210
    assert LD = 28
    assert RD = 15
    return ()
end

@external
func test_get_adjecent_wrapped_DR{
        range_check_ptr
    }():
    let (L, R, U, D, LU, RU, LD, RD) = get_adjecent(224)
    assert L = 223
    assert R = 210
    assert U = 209
    assert D = 14
    assert LU = 208
    assert RU = 195
    assert LD = 13
    assert RD = 0
    return ()
end

@external
func test_evaluate_rounds{
        syscall_ptr : felt*,
        bitwise_ptr : BitwiseBuiltin*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }():
    alloc_locals
    let (local cells : felt*) = alloc()

    assert cells[0] = 0
    assert cells[1] = 0
    assert cells[2] = 0
    assert cells[3] = 0
    assert cells[4] = 0
    assert cells[5] = 0
    assert cells[6] = 0
    assert cells[7] = 0
    assert cells[8] = 0
    assert cells[9] = 0
    assert cells[10] = 0
    assert cells[11] = 0
    assert cells[12] = 0
    assert cells[13] = 0
    assert cells[14] = 0
    assert cells[15] = 0
    assert cells[16] = 0
    assert cells[17] = 0
    assert cells[18] = 0
    assert cells[19] = 0
    assert cells[20] = 0
    assert cells[21] = 0
    assert cells[22] = 0
    assert cells[23] = 0
    assert cells[24] = 0
    assert cells[25] = 0
    assert cells[26] = 0
    assert cells[27] = 0
    assert cells[28] = 0
    assert cells[29] = 0
    assert cells[30] = 0
    assert cells[31] = 0
    assert cells[32] = 0
    assert cells[33] = 0
    assert cells[34] = 0
    assert cells[35] = 0
    assert cells[36] = 0
    assert cells[37] = 0
    assert cells[38] = 0
    assert cells[39] = 0
    assert cells[40] = 0
    assert cells[41] = 0
    assert cells[42] = 0
    assert cells[43] = 0
    assert cells[44] = 0
    assert cells[45] = 0
    assert cells[46] = 0
    assert cells[47] = 0
    assert cells[48] = 0
    assert cells[49] = 0
    assert cells[50] = 0
    assert cells[51] = 0
    assert cells[52] = 0
    assert cells[53] = 0
    assert cells[54] = 0
    assert cells[55] = 0
    assert cells[56] = 0
    assert cells[57] = 0
    assert cells[58] = 0
    assert cells[59] = 0
    assert cells[60] = 0
    assert cells[61] = 0
    assert cells[62] = 0
    assert cells[63] = 0
    assert cells[64] = 0
    assert cells[65] = 0
    assert cells[66] = 0
    assert cells[67] = 0
    assert cells[68] = 0
    assert cells[69] = 0
    assert cells[70] = 0
    assert cells[71] = 0
    assert cells[72] = 0
    assert cells[73] = 0
    assert cells[74] = 0
    assert cells[75] = 0
    assert cells[76] = 0
    assert cells[77] = 0
    assert cells[78] = 0
    assert cells[79] = 0
    assert cells[80] = 0
    assert cells[81] = 0
    assert cells[82] = 0
    assert cells[83] = 0
    assert cells[84] = 0
    assert cells[85] = 0
    assert cells[86] = 0
    assert cells[87] = 0
    assert cells[88] = 0
    assert cells[89] = 0
    assert cells[90] = 0
    assert cells[91] = 0
    assert cells[92] = 0
    assert cells[93] = 0
    assert cells[94] = 0
    assert cells[95] = 0
    assert cells[96] = 0
    assert cells[97] = 0
    assert cells[98] = 0
    assert cells[99] = 1
    assert cells[100] = 0
    assert cells[101] = 0
    assert cells[102] = 0
    assert cells[103] = 0
    assert cells[104] = 0
    assert cells[105] = 0
    assert cells[106] = 0
    assert cells[107] = 0
    assert cells[108] = 0
    assert cells[109] = 0
    assert cells[110] = 0
    assert cells[111] = 0
    assert cells[112] = 0
    assert cells[113] = 0
    assert cells[114] = 0
    assert cells[115] = 0
    assert cells[116] = 1
    assert cells[117] = 0
    assert cells[118] = 0
    assert cells[119] = 0
    assert cells[120] = 0
    assert cells[121] = 0
    assert cells[122] = 0
    assert cells[123] = 0
    assert cells[124] = 0
    assert cells[125] = 0
    assert cells[126] = 0
    assert cells[127] = 0
    assert cells[128] = 1
    assert cells[129] = 1
    assert cells[130] = 0
    assert cells[131] = 0
    assert cells[132] = 1
    assert cells[133] = 1
    assert cells[134] = 1
    assert cells[135] = 0
    assert cells[136] = 0
    assert cells[137] = 0
    assert cells[138] = 0
    assert cells[139] = 0
    assert cells[140] = 0
    assert cells[141] = 0
    assert cells[142] = 0
    assert cells[143] = 0
    assert cells[144] = 0
    assert cells[145] = 0
    assert cells[146] = 0
    assert cells[147] = 0
    assert cells[148] = 0
    assert cells[149] = 0
    assert cells[150] = 0
    assert cells[151] = 0
    assert cells[152] = 0
    assert cells[153] = 0
    assert cells[154] = 0
    assert cells[155] = 0
    assert cells[156] = 0
    assert cells[157] = 0
    assert cells[158] = 0
    assert cells[159] = 0
    assert cells[160] = 0
    assert cells[161] = 0
    assert cells[162] = 0
    assert cells[163] = 0
    assert cells[164] = 0
    assert cells[165] = 0
    assert cells[166] = 0
    assert cells[167] = 0
    assert cells[168] = 0
    assert cells[169] = 0
    assert cells[170] = 0
    assert cells[171] = 0
    assert cells[172] = 0
    assert cells[173] = 0
    assert cells[174] = 0
    assert cells[175] = 0
    assert cells[176] = 0
    assert cells[177] = 0
    assert cells[178] = 0
    assert cells[179] = 0
    assert cells[180] = 0
    assert cells[181] = 0
    assert cells[182] = 0
    assert cells[183] = 0
    assert cells[184] = 0
    assert cells[185] = 0
    assert cells[186] = 0
    assert cells[187] = 0
    assert cells[188] = 0
    assert cells[189] = 0
    assert cells[190] = 0
    assert cells[191] = 0
    assert cells[192] = 0
    assert cells[193] = 0
    assert cells[194] = 0
    assert cells[195] = 0
    assert cells[196] = 0
    assert cells[197] = 0
    assert cells[198] = 0
    assert cells[199] = 0
    assert cells[200] = 0
    assert cells[201] = 0
    assert cells[202] = 0
    assert cells[203] = 0
    assert cells[204] = 0
    assert cells[205] = 0
    assert cells[206] = 0
    assert cells[207] = 0
    assert cells[208] = 0
    assert cells[209] = 0
    assert cells[210] = 0
    assert cells[211] = 0
    assert cells[212] = 0
    assert cells[213] = 0
    assert cells[214] = 0
    assert cells[215] = 0
    assert cells[216] = 0
    assert cells[217] = 0
    assert cells[218] = 0
    assert cells[219] = 0
    assert cells[220] = 0
    assert cells[221] = 0
    assert cells[222] = 0
    assert cells[223] = 0
    assert cells[224] = 0

    let (local evolved_acorn : felt*) = evaluate_rounds(1, cells)

    assert evolved_acorn[0] = 0
    assert evolved_acorn[1] = 0
    assert evolved_acorn[2] = 0
    assert evolved_acorn[3] = 0
    assert evolved_acorn[4] = 0
    assert evolved_acorn[5] = 0
    assert evolved_acorn[6] = 0
    assert evolved_acorn[7] = 0
    assert evolved_acorn[8] = 0
    assert evolved_acorn[9] = 0
    assert evolved_acorn[10] = 0
    assert evolved_acorn[11] = 0
    assert evolved_acorn[12] = 0
    assert evolved_acorn[13] = 0
    assert evolved_acorn[14] = 0
    assert evolved_acorn[15] = 0
    assert evolved_acorn[16] = 0
    assert evolved_acorn[17] = 0
    assert evolved_acorn[18] = 0
    assert evolved_acorn[19] = 0
    assert evolved_acorn[20] = 0
    assert evolved_acorn[21] = 0
    assert evolved_acorn[22] = 0
    assert evolved_acorn[23] = 0
    assert evolved_acorn[24] = 0
    assert evolved_acorn[25] = 0
    assert evolved_acorn[26] = 0
    assert evolved_acorn[27] = 0
    assert evolved_acorn[28] = 0
    assert evolved_acorn[29] = 0
    assert evolved_acorn[30] = 0
    assert evolved_acorn[31] = 0
    assert evolved_acorn[32] = 0
    assert evolved_acorn[33] = 0
    assert evolved_acorn[34] = 0
    assert evolved_acorn[35] = 0
    assert evolved_acorn[36] = 0
    assert evolved_acorn[37] = 0
    assert evolved_acorn[38] = 0
    assert evolved_acorn[39] = 0
    assert evolved_acorn[40] = 0
    assert evolved_acorn[41] = 0
    assert evolved_acorn[42] = 0
    assert evolved_acorn[43] = 0
    assert evolved_acorn[44] = 0
    assert evolved_acorn[45] = 0
    assert evolved_acorn[46] = 0
    assert evolved_acorn[47] = 0
    assert evolved_acorn[48] = 0
    assert evolved_acorn[49] = 0
    assert evolved_acorn[50] = 0
    assert evolved_acorn[51] = 0
    assert evolved_acorn[52] = 0
    assert evolved_acorn[53] = 0
    assert evolved_acorn[54] = 0
    assert evolved_acorn[55] = 0
    assert evolved_acorn[56] = 0
    assert evolved_acorn[57] = 0
    assert evolved_acorn[58] = 0
    assert evolved_acorn[59] = 0
    assert evolved_acorn[60] = 0
    assert evolved_acorn[61] = 0
    assert evolved_acorn[62] = 0
    assert evolved_acorn[63] = 0
    assert evolved_acorn[64] = 0
    assert evolved_acorn[65] = 0
    assert evolved_acorn[66] = 0
    assert evolved_acorn[67] = 0
    assert evolved_acorn[68] = 0
    assert evolved_acorn[69] = 0
    assert evolved_acorn[70] = 0
    assert evolved_acorn[71] = 0
    assert evolved_acorn[72] = 0
    assert evolved_acorn[73] = 0
    assert evolved_acorn[74] = 0
    assert evolved_acorn[75] = 0
    assert evolved_acorn[76] = 0
    assert evolved_acorn[77] = 0
    assert evolved_acorn[78] = 0
    assert evolved_acorn[79] = 0
    assert evolved_acorn[80] = 0
    assert evolved_acorn[81] = 0
    assert evolved_acorn[82] = 0
    assert evolved_acorn[83] = 0
    assert evolved_acorn[84] = 0
    assert evolved_acorn[85] = 0
    assert evolved_acorn[86] = 0
    assert evolved_acorn[87] = 0
    assert evolved_acorn[88] = 0
    assert evolved_acorn[89] = 0
    assert evolved_acorn[90] = 0
    assert evolved_acorn[91] = 0
    assert evolved_acorn[92] = 0
    assert evolved_acorn[93] = 0
    assert evolved_acorn[94] = 0
    assert evolved_acorn[95] = 0
    assert evolved_acorn[96] = 0
    assert evolved_acorn[97] = 0
    assert evolved_acorn[98] = 0
    assert evolved_acorn[99] = 0
    assert evolved_acorn[100] = 0
    assert evolved_acorn[101] = 0
    assert evolved_acorn[102] = 0
    assert evolved_acorn[103] = 0
    assert evolved_acorn[104] = 0
    assert evolved_acorn[105] = 0
    assert evolved_acorn[106] = 0
    assert evolved_acorn[107] = 0
    assert evolved_acorn[108] = 0
    assert evolved_acorn[109] = 0
    assert evolved_acorn[110] = 0
    assert evolved_acorn[111] = 0
    assert evolved_acorn[112] = 0
    assert evolved_acorn[113] = 1
    assert evolved_acorn[114] = 1
    assert evolved_acorn[115] = 1
    assert evolved_acorn[116] = 0
    assert evolved_acorn[117] = 1
    assert evolved_acorn[118] = 1
    assert evolved_acorn[119] = 0
    assert evolved_acorn[120] = 0
    assert evolved_acorn[121] = 0
    assert evolved_acorn[122] = 0
    assert evolved_acorn[123] = 0
    assert evolved_acorn[124] = 0
    assert evolved_acorn[125] = 0
    assert evolved_acorn[126] = 0
    assert evolved_acorn[127] = 0
    assert evolved_acorn[128] = 0
    assert evolved_acorn[129] = 0
    assert evolved_acorn[130] = 0
    assert evolved_acorn[131] = 0
    assert evolved_acorn[132] = 1
    assert evolved_acorn[133] = 1
    assert evolved_acorn[134] = 0
    assert evolved_acorn[135] = 0
    assert evolved_acorn[136] = 0
    assert evolved_acorn[137] = 0
    assert evolved_acorn[138] = 0
    assert evolved_acorn[139] = 0
    assert evolved_acorn[140] = 0
    assert evolved_acorn[141] = 0
    assert evolved_acorn[142] = 0
    assert evolved_acorn[143] = 0
    assert evolved_acorn[144] = 0
    assert evolved_acorn[145] = 0
    assert evolved_acorn[146] = 0
    assert evolved_acorn[147] = 0
    assert evolved_acorn[148] = 1
    assert evolved_acorn[149] = 0
    assert evolved_acorn[150] = 0
    assert evolved_acorn[151] = 0
    assert evolved_acorn[152] = 0
    assert evolved_acorn[153] = 0
    assert evolved_acorn[154] = 0
    assert evolved_acorn[155] = 0
    assert evolved_acorn[156] = 0
    assert evolved_acorn[157] = 0
    assert evolved_acorn[158] = 0
    assert evolved_acorn[159] = 0
    assert evolved_acorn[160] = 0
    assert evolved_acorn[161] = 0
    assert evolved_acorn[162] = 0
    assert evolved_acorn[163] = 0
    assert evolved_acorn[164] = 0
    assert evolved_acorn[165] = 0
    assert evolved_acorn[166] = 0
    assert evolved_acorn[167] = 0
    assert evolved_acorn[168] = 0
    assert evolved_acorn[169] = 0
    assert evolved_acorn[170] = 0
    assert evolved_acorn[171] = 0
    assert evolved_acorn[172] = 0
    assert evolved_acorn[173] = 0
    assert evolved_acorn[174] = 0
    assert evolved_acorn[175] = 0
    assert evolved_acorn[176] = 0
    assert evolved_acorn[177] = 0
    assert evolved_acorn[178] = 0
    assert evolved_acorn[179] = 0
    assert evolved_acorn[180] = 0
    assert evolved_acorn[181] = 0
    assert evolved_acorn[182] = 0
    assert evolved_acorn[183] = 0
    assert evolved_acorn[184] = 0
    assert evolved_acorn[185] = 0
    assert evolved_acorn[186] = 0
    assert evolved_acorn[187] = 0
    assert evolved_acorn[188] = 0
    assert evolved_acorn[189] = 0
    assert evolved_acorn[190] = 0
    assert evolved_acorn[191] = 0
    assert evolved_acorn[192] = 0
    assert evolved_acorn[193] = 0
    assert evolved_acorn[194] = 0
    assert evolved_acorn[195] = 0
    assert evolved_acorn[196] = 0
    assert evolved_acorn[197] = 0
    assert evolved_acorn[198] = 0
    assert evolved_acorn[199] = 0
    assert evolved_acorn[200] = 0
    assert evolved_acorn[201] = 0
    assert evolved_acorn[202] = 0
    assert evolved_acorn[203] = 0
    assert evolved_acorn[204] = 0
    assert evolved_acorn[205] = 0
    assert evolved_acorn[206] = 0
    assert evolved_acorn[207] = 0
    assert evolved_acorn[208] = 0
    assert evolved_acorn[209] = 0
    assert evolved_acorn[210] = 0
    assert evolved_acorn[211] = 0
    assert evolved_acorn[212] = 0
    assert evolved_acorn[213] = 0
    assert evolved_acorn[214] = 0
    assert evolved_acorn[215] = 0
    assert evolved_acorn[216] = 0
    assert evolved_acorn[217] = 0
    assert evolved_acorn[218] = 0
    assert evolved_acorn[219] = 0
    assert evolved_acorn[220] = 0
    assert evolved_acorn[221] = 0
    assert evolved_acorn[222] = 0
    assert evolved_acorn[223] = 0
    assert evolved_acorn[224] = 0

    return ()
end
