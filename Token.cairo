%lang starknet

struct Storage: #variables for storage 
    balances: felt
    total_supply: felt
    cap: felt
    owner: felt
    paused: felt

#initialising contract with a cap and setting owner
@external
func initialize{syscall_ptr: felt*}(
    initial_cap: felt
):
    let caller = get_caller_address()
    Storage.cap.write(initial_cap)
    Storage.owner.write(caller)
    Storage.paused.write(0)  # Start unpaused
    return ()
end

#minting new tokens 
@external
func mint{syscall_ptr: felt*}(
    to: felt, amount: felt
):
    let caller = get_caller_address()
    assert caller == Storage.owner.read(), 'Only owner can mint'
    
    let new_supply = Storage.total_supply.read() + amount
    assert new_supply <= Storage.cap.read(), 'Exceeds cap'
    
    #update balances + total supply
    Storage.balances[to] = Storage.balances[to] + amount
    Storage.total_supply.write(new_supply)
    return ()
end

#burn tokens from caller's balance
@external
func burn{syscall_ptr: felt*}(
    amount: felt
):
    let caller = get_caller_address()
    let balance = Storage.balances[caller]
    
    # Check sufficient balance
    assert balance >= amount, 'Insufficient balance'
    
    # Update balance and total supply
    Storage.balances[caller] = balance - amount
    Storage.total_supply.write(Storage.total_supply.read() - amount)
    return ()
end

#transfer tokens to different address
@external
func transfer{syscall_ptr: felt*}(
    to: felt, amount: felt
):
    assert Storage.paused.read() == 0, 'Transfers are paused'
    let caller = get_caller_address()
    let sender_balance = Storage.balances[caller]
    
    assert sender_balance >= amount, 'Insufficient balance'
    
    # Update balances
    Storage.balances[caller] = sender_balance - amount
    Storage.balances[to] = Storage.balances[to] + amount
    return ()
end

#pause transfers 
@external
func pause{syscall_ptr: felt*}():
    let caller = get_caller_address()
    assert caller == Storage.owner.read(), 'Only owner can pause'
    Storage.paused.write(1)
    return ()
end

@external
func unpause{syscall_ptr: felt*}():
    let caller = get_caller_address()
    assert caller == Storage.owner.read(), 'Only owner can unpause'
    Storage.paused.write(0)
    return ()
end

#get balance of address
@view
func balance_of{syscall_ptr: felt*}(account: felt) -> (balance: felt):
    return (balance=Storage.balances[account])
end

@view
func get_total_supply{syscall_ptr: felt*}() -> (total: felt):
    return (total=Storage.total_supply.read())
end
