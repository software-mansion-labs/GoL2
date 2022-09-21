%lang starknet

@event
func game_created(user_id: felt, game_id: felt, state: felt) {
}

@event
func game_evolved(user_id: felt, game_id: felt, generation: felt, state: felt) {
}

@event
func cell_revived(user_id: felt, generation: felt, cell_index: felt, state: felt) {
}
