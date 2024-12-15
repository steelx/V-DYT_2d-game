/// @description obj_inventory Create event
enum INVENTORY_SLOTS {
    SWORD,
    BLITZ,
    THROW,
    HEAL
}

has_sword = true;

selected_slot = INVENTORY_SLOTS.SWORD;
heal_potions_max = 5;
heal_potions = 3; // Initial potions

slots = [
    {name: "Sword", color: c_white},
    {name: "Blitz", color: c_white},
    {name: "Empty", color: c_white},
    {name: "Heal", color: c_white}
];

// Cyberpunk colors
colors = {
    background: make_color_rgb(10, 10, 20),
    border: make_color_rgb(0, 255, 255),
    selected: make_color_rgb(255, 255, 0),
    text: c_white
};

blitz_points_max = 10;
blitz_points = blitz_points_max;
