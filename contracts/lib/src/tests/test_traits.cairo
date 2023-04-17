use array::ArrayTrait;
use lib::ArrayTraitExt;

#[test]
#[available_gas(2000000)]
fn test_append_all() {
    let mut destination = ArrayTrait::new();
    let mut source = ArrayTrait::new();
    destination.append(21);
    source.append(42);
    source.append(84);
    let mut source = source.span();
    destination.append_all(ref source);
    assert(destination.len() == 3, 'Len should be 3');
    assert(*destination.at(0) == 21, 'Should be 42');
    assert(*destination.at(1) == 42, 'Should be 21');
    assert(*destination.at(2) == 84, 'Should be 21');
}
#[test]
#[available_gas(2000000)]
fn test_append_all_destination_empty() {
    let mut destination = ArrayTrait::new();
    let mut source = ArrayTrait::new();
    source.append(21);
    source.append(42);
    source.append(84);
    let mut source = source.span();
    destination.append_all(ref source);
    assert(destination.len() == 3, 'Len should be 3');
    assert(*destination.at(0) == 21, 'Should be 42');
    assert(*destination.at(1) == 42, 'Should be 21');
    assert(*destination.at(2) == 84, 'Should be 21');
}

#[test]
#[available_gas(2000000)]
fn test_append_all_source_empty() {
    let mut destination = ArrayTrait::new();
    let mut source = ArrayTrait::new();
    destination.append(21);
    destination.append(42);
    destination.append(84);
    let mut source = source.span();
    destination.append_all(ref source);
    assert(destination.len() == 3, 'Len should be 3');
    assert(*destination.at(0) == 21, 'Should be 42');
    assert(*destination.at(1) == 42, 'Should be 21');
    assert(*destination.at(2) == 84, 'Should be 21');
}

#[test]
#[available_gas(2000000)]
fn test_append_all_both_empty() {
    let mut destination = ArrayTrait::new();
    let mut source: Array<felt252> = ArrayTrait::new();
    let mut source = source.span();
    destination.append_all(ref source);
    assert(destination.is_empty(), 'Should be empty');
}
