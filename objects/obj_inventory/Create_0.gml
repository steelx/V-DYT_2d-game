/// @description obj_inventory Create event
enum INVENTORY_SLOTS {
    SWORD,
    BLITZ,
    THROW,
    HEAL
}

// Cyberpunk colors
colors = {
    background: make_color_rgb(10, 10, 20),
    border: make_color_rgb(0, 255, 255),
    selected: make_color_rgb(255, 255, 0),
    text: c_white
};

has_sword = true;

selected_slot = INVENTORY_SLOTS.SWORD;
heal_potions_max = 5;
heal_potions = 3; // Initial potions

slots = [
    {name: "Sword", color: colors.text},
    {name: "Blitz", color: colors.text},
    {name: "Throw", color: colors.text},
    {name: "Heal", color: c_green}
];



blitz_points_max = 10;
blitz_points = blitz_points_max;
