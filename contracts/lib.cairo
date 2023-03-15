mod tests;

mod dummy_syscalls;
mod spans;

mod asserts;

mod argent_account;
use argent_account::ArgentAccount;

mod argent_multisig_account;
use argent_multisig_account::ArgentMultisigAccount;

mod erc20;
use erc20::ERC20;

mod test_dapp;
use test_dapp::TestDapp;

mod multicall;
use multicall::Multicall;
use multicall::Multicall::aggregate;

mod traits;
use traits::ArrayTraitExt;

// Structures 
mod calls;
use calls::Call;
use calls::execute_multicall;

mod escape;
use escape::Escape;
use escape::StorageAccessEscape;
use escape::EscapeSerde;

mod signer_signature;
use signer_signature::SignerSignature;
use signer_signature::deserialize_array_signer_signature;
use signer_signature::SignerSignatureSize;
