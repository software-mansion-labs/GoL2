%lang starknet
%builtins pedersen range_check bitwise

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bitwise import bitwise_and, bitwise_or
from starkware.cairo.common.cairo_builtins import (HashBuiltin,
    BitwiseBuiltin)
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.pow import pow
from starkware.starknet.common.storage import Storage


# Width of the simulation grid.
const DIM = 16


@storage_var
func spawned() -> (bool : felt):
end

# Stores n=dim rows of cell status as a binary representation.
@storage_var
func row_binary(
        row : felt
    ) -> (
        val : felt
    ):
end

# Sets the initial state.
@external
func spawn{
        storage_ptr : Storage*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }():
    let (has_spawned) = spawned.read()
    if has_spawned == 1:
        return ()
    end
    # Start with a 16x16 methuselah.
    # https://conwaylife.com/wiki/49768M
    row_binary.write(0, 32333)
    row_binary.write(1, 54472)
    row_binary.write(2, 1043)
    row_binary.write(3, 19359)
    row_binary.write(4, 53186)
    row_binary.write(5, 35818)
    row_binary.write(6, 55429)
    row_binary.write(7, 4183)
    row_binary.write(8, 64213)
    row_binary.write(9, 32877)
    row_binary.write(10, 18501)
    row_binary.write(11, 50706)
    row_binary.write(12, 45093)
    row_binary.write(13, 1293)
    row_binary.write(14, 60929)
    row_binary.write(15, 43246)
    spawned.write(1)
    return ()
end

@external
func run{
        storage_ptr : Storage*,
        bitwise_ptr : BitwiseBuiltin*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        rounds : felt,
        give_life_row_index : felt,
        give_life_column_index : felt
    ) -> (
        first_init : felt, # testing.
        last_init : felt,
        sample_new : felt
    ):
    alloc_locals
    # Unpack the stored game
    # Iterate over rows, then cols to get an array of all cells.
    let (local cell_states_init : felt*) = alloc()
    unpack_rows(cell_states=cell_states_init,row=DIM)
    local first_cell : felt = cell_states_init[0]
    local last_cell : felt = cell_states_init[DIM*DIM - 1]
    # Run the game for the specified rounds.
    let (local cell_states : felt*) = evaluate_rounds(rounds, cell_states_init)
    # Pack the game for storage.
    pack_rows(cell_states, row=DIM)

    activate_cell(give_life_row_index, give_life_column_index)
    return (first_cell, last_cell, cell_states[3])
end

@view
func view_game{
        storage_ptr : Storage*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (
        row_0 : felt, row_1 : felt, row_2 : felt, row_3 : felt,
        row_4 : felt, row_5 : felt, row_6 : felt, row_7 : felt,
        row_8 : felt, row_9 : felt, row_10 : felt, row_11 : felt,
        row_12 : felt, row_13 : felt, row_14 : felt, row_15 : felt
    ):
    let (row_0) = row_binary.read(0)
    let (row_1) = row_binary.read(1)
    let (row_2) = row_binary.read(2)
    let (row_3) = row_binary.read(3)
    let (row_4) = row_binary.read(4)
    let (row_5) = row_binary.read(5)
    let (row_6) = row_binary.read(6)
    let (row_7) = row_binary.read(7)
    let (row_8) = row_binary.read(8)
    let (row_9) = row_binary.read(9)
    let (row_10) = row_binary.read(10)
    let (row_11) = row_binary.read(11)
    let (row_12) = row_binary.read(12)
    let (row_13) = row_binary.read(13)
    let (row_14) = row_binary.read(14)
    let (row_15) = row_binary.read(15)
    return (row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7,
        row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15)
end

# Pre-sim. Walk columns for a given row and saves state to an array.
func unpack_cols{
        storage_ptr : Storage*,
        bitwise_ptr : BitwiseBuiltin*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        cell_states : felt*,
        row : felt,
        col : felt,
        stored_row : felt
    ):
    alloc_locals
    if col == 0:
        return ()
    end

    unpack_cols(cell_states=cell_states,
        row=row, col=col-1, stored_row=stored_row)
    # (Note, on first entry, col=1 so col-1 gets the index)
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local cell_states : felt* = cell_states
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr
    # state = 2**column_index AND row_binary
    let (mask) = pow(2, col-1)
    let (state) = bitwise_and(stored_row, mask)
    let index = row * DIM + col-1
    assert cell_states[index] = state

    return ()
end

# Pre-sim. Walk rows then columns to build state.
func unpack_rows{
        storage_ptr : Storage*,
        bitwise_ptr : BitwiseBuiltin*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        cell_states : felt*,
        row : felt
    ):
    if row == 0:
        return ()
    end

    unpack_rows(cell_states=cell_states, row=row-1)
    # Get the binary encoded store.
    # (Note, on first entry, row=1 so row-1 gets the index)
    let (stored_row) = row_binary.read(row=row-1)
    unpack_cols(cell_states=cell_states,
        row=row-1, col=DIM, stored_row=stored_row)

    return ()
end

# Executes rounds and returns an array with final state.
func evaluate_rounds{
        storage_ptr : Storage*,
        bitwise_ptr : BitwiseBuiltin*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        rounds : felt,
        cell_states : felt*
    ) -> (
        cell_states : felt*
    ):
    alloc_locals
    if rounds == 0:
        return(cell_states=cell_states)
    end

    let (cell_states) = evaluate_rounds(rounds=rounds-1, cell_states=cell_states)

    let (local pending_states : felt*) = alloc()
    # Fill up pending_states based on cell_states and GoL rules
    apply_rules(cell=DIM*DIM, cell_states=cell_states,
        pending_states=pending_states)

    # Return the pending states as canonical.
    return (cell_states=pending_states)
end

func apply_rules{
        storage_ptr : Storage*,
        bitwise_ptr : BitwiseBuiltin*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        cell : felt,
        cell_states : felt*,
        pending_states : felt*
    ):
    alloc_locals
    if cell == 0:
        return ()
    end

    apply_rules(cell=cell-1, cell_states=cell_states,
        pending_states=pending_states)

    # (Note, on first entry, cell=1 so cell-1 gets the index)
    local cell_idx = cell - 1

    #local cell_states : felt* = cell_states
    local storage_ptr : Storage* = storage_ptr
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr
    local pedersen_ptr : HashBuiltin* = pedersen_ptr


    let (row, col) = unsigned_div_rem(cell_idx, DIM)
    let len = DIM * DIM
    # Wrap around: Index neihbours using modulo array length.
    let (_, L) = unsigned_div_rem(cell_idx - 1 + len, len)
    let (_, R) = unsigned_div_rem(cell_idx + 1, len)
    let (_, D) = unsigned_div_rem(cell_idx + DIM, len)
    let (_, U) = unsigned_div_rem(cell_idx - DIM + len, len)
    let (_, LU) = unsigned_div_rem(U - 1 + len, len)
    let (_, RU) = unsigned_div_rem(U + 1, len)
    let (_, LD) = unsigned_div_rem(D - 1 + len, len)
    let (_, RD) = unsigned_div_rem(D + 1, len)

    local range_check_ptr = range_check_ptr
    # Sum of 8 surrounding cells.
    let score = cell_states[L] + cell_states[R] +
        cell_states[D] + cell_states[U] +
        cell_states[LU] + cell_states[RU] +
        cell_states[LD] + cell_states[RD]

    # Final outcome

    assert pending_states[cell_idx] = 0
    # If alive
    if cell_states[cell_idx] == 1:
        # With good neighbours
        if (score - 2) * (score - 3) == 0:
            # Live
            assert pending_states[cell_idx] = 1
        end
    else:
        if score == 3:
            assert pending_states[cell_idx] = 1
        end
    end

    return ()
end

# User input may override state to make a cell alive.
func activate_cell{
        storage_ptr : Storage*,
        bitwise_ptr : BitwiseBuiltin*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        row : felt,
        col : felt
    ):
    alloc_locals
    # Wrap around if chosen value out of range.
    let (_, local row) = unsigned_div_rem(row, DIM)
    let (_, col) = unsigned_div_rem(col, DIM)
    # 000...0000001000000 Selected bit (column) for this row.
    # 000...0100100001010 Stored.
    # 000...0100101001010 Selected OR Stored.
    #                 ^ index 2
    let binary_position = DIM - col
    let (local bit) = pow(2, binary_position)
    let (stored) = row_binary.read(row)
    let (updated) = bitwise_or(bit, stored)
    row_binary.write(row, updated)

    return ()
end

# Post-sim. Walk columns for a given row and saves array to state.
func pack_cols{
        storage_ptr : Storage*,
        bitwise_ptr : BitwiseBuiltin*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        cell_states : felt*,
        row : felt,
        col : felt,
        row_to_store : felt
    ) -> (
        row_to_store : felt
    ):
    alloc_locals
    if col == 0:
        return (row_to_store)
    end
    # Loops over columns, adding to a single felt using a mask.
    let (local row_to_store) = pack_cols(cell_states=cell_states,
        row=row, col=col-1, row_to_store=row_to_store)
    # (Note, on first entry, col=1 so col-1 gets the index)

    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    local storage_ptr : Storage* = storage_ptr
    local cell_states : felt* = cell_states
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr


    # Get index of cell in cell_state for this row-col combo.
    # "Move 'row length' blocks down list, then add the column index".
    let index = row * DIM + (col - 1)
    let state = cell_states[index]

    # col=0 goes in MSB. col=DIM goes in LSB.
    let binary_position = DIM - (col - 1)
    # 000...00000000011 row_to_store (old aggregator)
    # 000...00000001000 cell_binary (cell state)
    # 000...00000001011 bitwise OR (new aggregator)

    # Binary = state * bit = state * 2**column_index
    # E.g., For index-0: 1 * 2**0 = 0b1
    # E.g., For index-2: 1 * 2**2 = 0b100

    let (bit) = pow(2, binary_position)
    let cell_binary = state * bit
    # store = store OR row_binary
    let (new_row) = bitwise_or(cell_binary, row_to_store)

    return (new_row)
end

# Post-sim. Walk rows then columns to store state.
func pack_rows{
        storage_ptr : Storage*,
        bitwise_ptr : BitwiseBuiltin*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        cell_states : felt*,
        row : felt
    ):
    if row == 0:
        return ()
    end

    pack_rows(cell_states=cell_states, row=row-1)
    # (Note, on first entry, row=1 so row-1 gets the index)
    # Create the binary encoded state for the row.
    let (row_to_store) = pack_cols(cell_states=cell_states,
        row=row-1, col=DIM, row_to_store=0)
    row_binary.write(row=row-1, value=row_to_store)

    return ()
end