namespace Generate {
    bool OnMouseButton(bool down, int button_idx, int x, int y) {
        auto editor = Editor();
        if (editor is null) return false;

        if (button_idx == 0 && down) {
            for (int i = 0; i < Button::button_enum::max_action; i++) {
                auto button = Button::button_dict.Get(i);
                if (button.isHovered) {
                    if (button.action == button_dict::)
                } 
            }
        }
    }
}