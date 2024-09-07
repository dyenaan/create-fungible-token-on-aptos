
module aptos_asset::fungible_asset{
    use aptos_framework::fungible_asset::{Self, MintRef, TransferRef, BurnRef, Metadata, FungibleAsset};
    use aptos_framework::object::{Self, Object};
    use aptos_framework::primary_fungible_store;
    use std::error;
    use std::signer;
    use std::string::utf8;
    use std::option;


    const ENOT_OWNER: u64 = 1;

    const ASSET_SYMBOL: vector<u8> = b"APTOLIA"

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    //Hold ref to control minting, transferring, and burning of the asset
    struct ManagedFungibleAsset has key{
        mint_ref: MintRef, // Reference for minting assets
        transfer_ref: TransferRef, //Reference for transferring assets
        burn_ref: BurnRef, //Reference for burning assets
    }
    entry fun init_module(admin: &signer){
        let constructor_ref = &object::create_named_object(admin, ASSET_SYMBOL);

        primary_fungible_store::create_primary_fungible_store_enabled_fungible_asset(
            constructor_ref,
            option::none(),
            uft8(b"AptoVerse Coin),
            uft8(ASSET_SYMBOL),
            8,
            uft8(b"https://drive.google.com/file/d/1hwf_j5IZ9UmqPLEtLspSnCdM7zslpVq9/view?usp=sharing"),
            option::none(),
        );
        let mint_ref = fungible_asset::generate_mint_ref(constructor_ref);
        let transfer_ref = fungible_asset::generate_transfer_ref(constructor_ref);
        let burn_ref = fungible_asset::generate_burn_ref(constructor_ref);

        let metadata_object_signer = object::generate_signer(constructor_ref);


        move_to(&metadata_object_signer, ManagedFungibleAsset{
            mint_ref,
            transfer_ref,
            burn_ref,
        });
    }
    #[view]
    public fun get_metadata(): Object<Metadata>{
        let asset_address = object::create_object_address(&@aptos_asset, ASSET_SYMBOL);
        object::address_to_object<Metadata>(asset_address)
    }
}