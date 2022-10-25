namespace Button {
    enum button_enum {
        generate_random_block,
        max_action,
    };

    CustomButton@ generate_random_block = CustomButton(
        button_enum::generate_random_block, Icons::Digitalocean,
        20, 20, 300, 20, hintText="Generate Random Block"
    );

    dictionary button_dict = {{button_enum::generate_random_block, generate_random_block}}
}