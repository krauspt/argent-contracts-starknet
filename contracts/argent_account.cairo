const ERC165_IERC165_INTERFACE_ID: felt = 0x01ffc9a7;
const ERC165_INVALID_INTERFACE_ID: felt = 0xffffffff;
const ERC165_ACCOUNT_INTERFACE_ID: felt = 0xa66bd575;
const ERC165_OLD_ACCOUNT_INTERFACE_ID: felt = 0x3943f10f;

#[contract]
mod ArgentAccount {
    
    struct Storage { 
        signer: felt,
        guardian: felt,
        guardian_backup: felt,
        // supportedInterfaces named in camelCase to match OZ's ERC165Storage but without a 
        // leading underscore because underscores have a specific meaning in Rust.
        supportedInterfaces: Map::<felt, bool>, 
    }

    #[external]
    fn initialize(signer: felt, guardian: felt, guardian_backup: felt) {
        // check that we are not already initialized
        assert(signer::read() == 0, 'argent: already initialized');
        // check that the target signer is not zero
        assert(signer != 0, 'argent: signer cannot be null');
        // initialize the account
        signer::write(signer);
        guardian::write(guardian);
        guardian_backup::write(guardian_backup);
    }

    #[view]
    fn get_signer() -> felt {
        signer::read()
    }

    #[view]
    fn get_guardian() -> felt {
        guardian::read()
    }

    #[view]
    fn get_guardian_backup() -> felt {
        guardian_backup::read()
    }

    // ERC165

    #[view]
    fn supportsInterface(interface_id: felt) -> bool {
        // using combination of hardcoding and dynamic lookup for tradeoff between performance and flexibility
        if (
            interface_id == super::ERC165_IERC165_INTERFACE_ID | 
            interface_id == super::ERC165_ACCOUNT_INTERFACE_ID |
            interface_id == super::ERC165_OLD_ACCOUNT_INTERFACE_ID
        ) {
            true 
        } else {
            supportedInterfaces::read(interface_id)
        }
    }

    #[external]
    fn register_interface(interface_id: felt) {
        // assert_only_self()
        supportedInterfaces::write(interface_id, true);
    }
}

#[test]
#[available_gas(20000)]
fn initialize() {
    ArgentAccount::initialize(1, 2, 3);
    assert(ArgentAccount::get_signer() == 1, 'value should be 1');
    assert(ArgentAccount::get_guardian() == 2, 'value should be 2');
    assert(ArgentAccount::get_guardian_backup() == 3, 'value should be 3');
}

#[test]
#[available_gas(20000)]
#[should_panic(expected = 'argent: signer cannot be null')]
fn initialize_with_null_signer() {
    ArgentAccount::initialize(0, 2, 3);
}

#[test]
#[available_gas(20000)]
#[should_panic(expected = 'argent: already initialized')]
fn already_initialized() {
    ArgentAccount::initialize(1, 2, 3);
    assert(ArgentAccount::get_signer() == 1, 'value should be 1');
    ArgentAccount::initialize(10, 20, 0);
}

#[test]
#[available_gas(20000)]
fn erc165_unsupported_interfaces() {
    assert(ArgentAccount::supportsInterface(0) == false, 'value should be false');
    assert(ArgentAccount::supportsInterface(ERC165_INVALID_INTERFACE_ID) == false, 'value should be false');
}

#[test]
#[available_gas(20000)]
fn erc165_supported_interfaces() {
    assert(ArgentAccount::supportsInterface(ERC165_IERC165_INTERFACE_ID) == true, 'value should be true');
    assert(ArgentAccount::supportsInterface(ERC165_ACCOUNT_INTERFACE_ID) == true, 'value should be true');
    assert(ArgentAccount::supportsInterface(ERC165_OLD_ACCOUNT_INTERFACE_ID) == true, 'value should be true');
}

#[test]
#[available_gas(20000)]
fn erc165_interface_registering() {
    assert(ArgentAccount::supportsInterface(0x12345678) == false, 'value should be false');
    ArgentAccount::register_interface(0x12345678);
    assert(ArgentAccount::supportsInterface(0x12345678) == true, 'value should be true');

    // TODO(axel): add test making sure register_interface can only be called by self
}
