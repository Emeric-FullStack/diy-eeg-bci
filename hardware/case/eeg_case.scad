// =============================================================================
//  Boîtier casque EEG — Arduino UNO R4 WiFi + 2 × BioAmp EXG Pill
//  Modèle paramétrique OpenSCAD, deux pièces : fond (base) + capot (lid)
//
//  Licence : CERN-OHL-P v2 — voir hardware/LICENSE
//  SPDX-License-Identifier: CERN-OHL-P-2.0
//  Testé avec OpenSCAD 2021.01
// =============================================================================
//
//  REPÈRE
//    Origine = coin extérieur bas-gauche du fond, Z vers le haut, en mm.
//    X = longueur de l'Arduino (USB-C sur la paroi X = 0), Y = largeur.
//    Les cotes Arduino sont celles du plan mécanique du datasheet ABX00087
//    (§13 « Mounting Holes And Board Outline »), origine au coin bas-gauche
//    du PCB, USB-C à gauche.
//
//  PRINCIPE
//    - Le fond porte l'Arduino sur 4 bossages (vis M3 courtes autotaraudeuses)
//      et une languette d'emboîtement sur tout le pourtour.
//    - Le capot porte les 2 BioAmp dans deux logements en U moulés sous le
//      plateau supérieur : les pills s'y clipsent par-dessous, composants
//      (TL084 + JST) vers le bas, dos contre le capot. Les connecteurs JST
//      regardent la paroi +Y, où une fente laisse sortir les 6 câbles
//      d'électrodes avec `cable_margin` (15 mm) devant les JST.
//    - Fenêtre USB-C sur la paroi X = 0 (toit à 45°, sans support), fenêtre
//      sur la matrice LED dans le plateau du capot.
//    - Les deux pièces s'impriment sans support : fond à l'endroit, capot
//      retourné (plateau sur le plateau d'impression). Voir part = "print".
//
//  Les variables marquées « À MESURER » sont des estimations : à vérifier sur
//  le matériel réel avant d'exporter un STL définitif. Celles marquées
//  « À VÉRIFIER » viennent de la lecture d'un plan ou d'une image (pas d'un
//  fichier CAO) et méritent un contrôle au pied à coulisse.
// =============================================================================

/* [Affichage] */
// "assembly" = boîtier fermé (avec `explode`), "print" = les 2 pièces posées pour impression
part = "assembly"; // ["assembly", "print", "base", "lid"]
// Afficher les composants fantômes (Arduino, pills, câbles)
show_components = true;
// Écartement du capot en vue assemblée (mm)
explode = 0;
$fn = 48;

/* [Arduino UNO R4 WiFi — datasheet ABX00087 §13] */
ard_l = 68.58;            // longueur PCB
ard_w = 53.34;            // largeur PCB
ard_t = 1.6;              // épaisseur PCB
// Trous de fixation [x, y] depuis le coin bas-gauche du PCB (gabarit UNO)
ard_holes = [[13.97, 2.54], [15.24, 50.80], [66.04, 7.62], [66.04, 35.56]];
ard_hole_d = 3.2;         // 4 × R1.6
ard_header_h = 8.5;       // hauteur des connecteurs femelles (datasheet, vue de côté)
ard_comp_h = 11.0;        // plus haut composant au-dessus du PCB : jack DC J5 — À MESURER
// USB-C (J1) : position du centre sur le bord X = 0 — À VÉRIFIER
// (déduit du plan : 0.73 + 6.4 + 3.88 = 11.01 mm sous le bord haut, largeur CX90B-16P 8.94)
usb_y = 37.9;
usb_w = 8.94;             // largeur du réceptacle
usb_h = 3.26;             // hauteur du réceptacle au-dessus du PCB
usb_overhang = 1.3;       // dépassement hors PCB (« 2x 1.3 mm » sur le plan)
usb_cut_w = 13.0;         // largeur de la fenêtre USB-C (surmoulage du câble) — À MESURER
usb_cut_h = 8.0;          // hauteur de la fenêtre USB-C (surmoulage du câble) — À MESURER
// Matrice LED 12×8 (U_LEDMATRIX) : centre et emprise, depuis le coin bas-gauche du PCB — À VÉRIFIER
// (mesuré sur la vue « Board Topology » du datasheet, ±1 mm)
led_center = [46.2, 19.0];
led_size = [25.8, 17.5];
led_window_margin = 1.5;  // marge de la fenêtre autour de la matrice
led_diffuser_t = 0;       // 0 = fenêtre ouverte ; 0.6 = membrane diffusante imprimée (PLA clair)
// Connecteur Qwiic (J2) sur le bord X = ard_l : fenêtre optionnelle
qwiic_cut = false;
qwiic_y = 13.8;           // centre Qwiic depuis le bord bas — À VÉRIFIER
qwiic_cut_w = 9.0;
qwiic_cut_h = 6.0;

/* [BioAmp EXG Pill — KiCad upsidedownlabs/BioAmp-EXG-Pill (hardware/, rev 1.0)] */
pill_l = 25.4;            // Edge.Cuts : 110.94 → 136.34
pill_w = 10.0;            // Edge.Cuts : 89.46 → 99.46
pill_t = 1.6;             // (general (thickness 1.6))
pill_r = 1.0;             // rayon des coins (gr_arc Edge.Cuts)
pill_pin_pitch = 2.54;    // 3 pastilles castellées à chaque extrémité, centrées sur la largeur
// Hauteur max côté composants (face TL084 + JST) — À MESURER
// 6.0 = JST PH side-entry ; mettre 8.5 si un header 2,54 est soudé pointes vers le bas
pill_comp_h = 6.0;
// Dégagement côté dos (0603 + jumpers de soudure ≈ 0.6 mm, à ≥ 1.8 mm des bords longs) — À MESURER
pill_back_h = 0.8;
// Connecteur JST PH 2.0 mm 3 broches, side-entry, soudé sur les pastilles REF/IN+/IN- — À MESURER
jst_w = 7.9;              // largeur du boîtier (≈ (3-1)×2.0 + 3.9)
jst_len = 6.0;            // profondeur du boîtier sur le PCB
jst_h = 6.0;              // hauteur du boîtier au-dessus du PCB
jst_overhang = 2.0;       // dépassement du boîtier au-delà du bord du PCB — À MESURER
// Marge libre devant les JST pour la prise et la courbure du câble
cable_margin = 15.0;

/* [Boîtier] */
wall = 1.6;               // parois
floor_t = 1.6;            // fond
top_t = 1.6;              // plateau du capot
corner_r = 3.0;           // rayon des coins verticaux extérieurs
pcb_clear = 1.5;          // jeu PCB Arduino ↔ paroi interne (USB-C et jack dépassent de 1.3) — À MESURER
standoff_h = 4.0;         // hauteur des bossages sous l'Arduino
boss_d = 6.5;             // diamètre des bossages
screw_pilot_d = 2.5;      // avant-trou pour vis M3 autotaraudeuse — À MESURER (2.5–2.8 selon l'imprimante)
screw_depth = 5.0;        // profondeur de l'avant-trou (vis M3 × 6 à travers 1.6 de PCB)
// Espace entre le plus haut composant Arduino et le dessous des BioAmp — À MESURER
// (passage des 3 fils OUT/GND/VCC ; ≥ 14 si des boîtiers Dupont passent sous les pills)
wire_clear = 3.0;
pill_clear = 0.3;         // jeu autour du PCB du pill dans son logement — À MESURER (selon imprimante)
pocket_wall = 1.2;        // paroi des logements BioAmp
ledge_w = 1.0;            // appui du dos du pill le long des bords longs
nub = 0.4;                // ergots de retenue sous le PCB (0 = désactivé)
nub_h = 0.6;
jst_pass_clear = 0.5;     // jeu latéral autour du JST au passage de l'extrémité du logement
lip_h = 3.0;              // hauteur de la languette d'emboîtement fond/capot
lip_t = 0.8;              // épaisseur de la languette
fit_clear = 0.15;         // jeu languette ↔ capot — À MESURER (selon imprimante)
pill_block_x = 1.3;       // décalage du bloc BioAmp depuis la paroi X = 0 (doit dégager la languette)
slot_w = 26.0;            // largeur de la fente câbles (6 câbles + 2 prises JST)
slot_extra_h = 1.0;       // hauteur de fente au-dessus du dessus des prises JST

/* [Fixation casque — à définir] */
// Vide pour l'instant : le support du casque sera mesuré plus tard.
mount_type = "none";      // ["none"]
mount_params = [];        // À MESURER : cotes du support du casque

// =============================================================================
//  Cotes dérivées
// =============================================================================
in_x = ard_l + 2 * pcb_clear;
in_y = ard_w + 2 * pcb_clear;
out_x = in_x + 2 * wall;
out_y = in_y + 2 * wall;
ard_x0 = wall + pcb_clear;          // coin bas-gauche du PCB Arduino (X)
ard_y0 = wall + pcb_clear;          // (Y)

z_pcb_bot = floor_t + standoff_h;   // dessous du PCB Arduino
z_pcb_top = z_pcb_bot + ard_t;      // dessus du PCB Arduino
z_ard_top = z_pcb_top + ard_comp_h; // sommet du plus haut composant Arduino
z_split = z_ard_top + lip_h;        // plan de joint fond/capot (haut de la paroi du fond)
z_pill_bot = z_ard_top + wire_clear;// point bas de la pile BioAmp (dessous des JST)
pill_stack = pill_comp_h + pill_t + pill_back_h;
z_lid_in = z_pill_bot + pill_stack; // dessous du plateau du capot
z_top = z_lid_in + top_t;           // dessus du boîtier
z_pill_pcb_bot = z_pill_bot + pill_comp_h;  // face composants du pill
z_pill_pcb_top = z_pill_pcb_bot + pill_t;   // dos du pill

pill_ch_w = pill_w + 2 * pill_clear;                   // largeur d'un logement
pill_ch_l = pill_l + 2 * pill_clear;                   // longueur d'un logement
block_w = 2 * pill_ch_w + 3 * pocket_wall;             // bloc des 2 logements
block_l = pill_ch_l + 2 * pocket_wall;
block_x0 = wall + pill_block_x;
pill_y1 = out_y - wall - cable_margin - jst_overhang;  // bord JST du PCB du pill
pill_y0 = pill_y1 - pill_l;                            // bord OUT/GND/VCC
block_y0 = pill_y0 - pill_clear - pocket_wall;
pill_cx = [block_x0 + pocket_wall + pill_ch_w / 2,
           block_x0 + 2 * pocket_wall + 1.5 * pill_ch_w];
block_cx = block_x0 + block_w / 2;

z_slot_top = z_pill_bot + jst_h + slot_extra_h;        // haut de la fente câbles
slot_r = min(3, slot_w / 4);
z_usb_bot = z_pcb_top + usb_h / 2 - usb_cut_h / 2;     // bas de la fenêtre USB-C
screw_depth_eff = min(screw_depth, standoff_h + floor_t - 0.6);  // garde ≥ 0.6 mm de fond
lip_in = fit_clear + lip_t;                            // retrait intérieur de la languette

led_win = [led_size[0] + 2 * led_window_margin, led_size[1] + 2 * led_window_margin];
led_win_x0 = ard_x0 + led_center[0] - led_win[0] / 2;
led_win_y0 = ard_y0 + led_center[1] - led_win[1] / 2;

// Contrôles de cohérence
assert(z_slot_top <= z_lid_in - 0.5, "La fente câbles monte dans le plateau : augmenter pill_back_h ou réduire slot_extra_h");
assert(block_x0 + block_w <= led_win_x0 - 0.5, "Le bloc BioAmp recouvre la fenêtre LED : déplacer led_center ou pill_block_x");
assert(pill_block_x >= lip_in + 0.1, "pill_block_x doit dégager la languette (fit_clear + lip_t)");
assert(pill_y0 >= wall + pocket_wall + pill_clear + 1, "Les pills ne tiennent pas en Y : réduire cable_margin ou jst_overhang");
assert(z_usb_bot > floor_t, "La fenêtre USB-C descend dans le fond : réduire usb_cut_h");
assert(z_usb_bot + usb_cut_h + usb_cut_w / 2 <= z_split - 0.5, "La fenêtre USB-C monte dans le plan de joint : réduire usb_cut_h/usb_cut_w");
assert(slot_w <= in_x - 2 * corner_r, "slot_w trop large pour la paroi");

echo(str("Boîtier extérieur : ", out_x, " × ", out_y, " × ", z_top, " mm"));
echo(str("Plan de joint z = ", z_split, " ; dessous des BioAmp z = ", z_pill_bot,
         " ; fente câbles z = ", z_split, " → ", z_slot_top));

// =============================================================================
//  Primitives
// =============================================================================
module rrect(size, r) {
    offset(r = r) offset(delta = -r) square(size);
}
module outer_profile() {
    rrect([out_x, out_y], corner_r);
}
// Profil intérieur de la cavité, éventuellement rétréci de `inset` (négatif = élargi)
module inner_profile(inset = 0) {
    translate([wall + inset, wall + inset])
        rrect([in_x - 2 * inset, in_y - 2 * inset], max(corner_r - wall - inset, 0.3));
}
// Fenêtre « maison » (toit à 45°, imprimable sans support) percée dans une paroi
// perpendiculaire à X, de largeur w (le long de Y) et de hauteur h sous le toit.
module house_cut_x(w, h, y_c, z_bot, x0, len) {
    translate([x0, 0, 0]) rotate([90, 0, 90])
        linear_extrude(len)
            polygon([[y_c - w / 2, z_bot], [y_c + w / 2, z_bot],
                     [y_c + w / 2, z_bot + h], [y_c, z_bot + h + w / 2],
                     [y_c - w / 2, z_bot + h]]);
}

// =============================================================================
//  Fixation casque (vide pour l'instant)
// =============================================================================
module headset_mount() {
    // À MESURER : support du casque. Ajouter ici la géométrie (pattes, rail, vis…)
    // en fonction de `mount_type` / `mount_params`. Rien n'est généré tant que
    // mount_type == "none".
    if (mount_type != "none") {
        echo("headset_mount(): mount_type non implémenté");
    }
}

// =============================================================================
//  Fond : porte l'Arduino
// =============================================================================
module base() {
    difference() {
        union() {
            // coque
            difference() {
                linear_extrude(z_split) outer_profile();
                translate([0, 0, floor_t]) linear_extrude(z_split) inner_profile();
            }
            // languette d'emboîtement : dépasse de lip_h au-dessus du plan de joint,
            // raccordée à la paroi en dessous par 3 marches (pas de porte-à-faux)
            translate([0, 0, z_split - 0.01])
                linear_extrude(lip_h + 0.01)
                    difference() {
                        inner_profile(-0.05);
                        inner_profile(lip_in);
                    }
            for (i = [0 : 2])
                translate([0, 0, z_split - lip_h + i * lip_h / 3])
                    linear_extrude(lip_h / 3 + 0.02)
                        difference() {
                            inner_profile(-0.05);
                            inner_profile(lip_in * (i + 1) / 3);
                        }
            // bossages
            for (h = ard_holes)
                translate([ard_x0 + h[0], ard_y0 + h[1], floor_t - 0.01])
                    cylinder(d = boss_d, h = standoff_h + 0.01);
            headset_mount();
        }
        // avant-trous M3
        for (h = ard_holes)
            translate([ard_x0 + h[0], ard_y0 + h[1], z_pcb_bot - screw_depth_eff])
                cylinder(d = screw_pilot_d, h = screw_depth_eff + 1);
        // fenêtre USB-C (paroi X = 0)
        house_cut_x(usb_cut_w, usb_cut_h, ard_y0 + usb_y, z_usb_bot, -1, wall + lip_in + 1.5);
        // fenêtre Qwiic optionnelle (paroi X = out_x)
        if (qwiic_cut)
            house_cut_x(qwiic_cut_w, qwiic_cut_h, ard_y0 + qwiic_y, z_pcb_top - 0.5,
                        out_x - wall - lip_in - 0.5, wall + lip_in + 1.5);
        // la languette s'efface sous la fente câbles (paroi +Y)
        translate([block_cx - slot_w / 2, out_y - wall - lip_in - 0.5, z_split])
            cube([slot_w, lip_in + 0.45, lip_h + 1]);
    }
}

// =============================================================================
//  Capot : couvre les BioAmp, fenêtre LED, fente câbles
// =============================================================================
module pill_block() {
    difference() {
        translate([block_x0, block_y0, z_pill_bot])
            cube([block_w, block_l, pill_stack + 0.5]);  // +0.5 : fusion avec le plateau
        for (cx = pill_cx) {
            // logement du PCB + composants (ouvert vers le bas) ; le dos du PCB bute sur l'appui
            translate([cx - pill_ch_w / 2, pill_y0 - pill_clear, z_pill_bot - 1])
                cube([pill_ch_w, pill_ch_l, pill_comp_h + pill_t + 1]);
            // dégagement du dos (composants arrière), bordé par l'appui `ledge_w`
            translate([cx - pill_ch_w / 2 + ledge_w, pill_y0 - pill_clear + ledge_w, z_pill_pcb_top - 0.01])
                cube([pill_ch_w - 2 * ledge_w, pill_ch_l - ledge_w + 0.01, pill_back_h + 0.02]);
            // passage du JST et de sa prise dans la paroi +Y du logement
            translate([cx - jst_w / 2 - jst_pass_clear, pill_y1 + pill_clear - 0.01, z_pill_bot - 1])
                cube([jst_w + 2 * jst_pass_clear, pocket_wall + 1, pill_comp_h + 1 + pill_clear]);
        }
    }
    // ergots de retenue sous la face composants du PCB : dessus plat, dessous chanfreiné
    if (nub > 0)
        for (cx = pill_cx, side = [-1, 1], yy = [pill_y0 + 3, pill_y1 - 3])
            translate([cx + side * (pill_ch_w / 2), yy, z_pill_pcb_bot - 0.1 - nub_h])
                rotate([0, 0, side > 0 ? 180 : 0])  // la pointe regarde vers l'intérieur du logement
                    hull() {
                        translate([-0.2, -1.5, 0]) cube([0.21, 3, nub_h]);
                        translate([nub - 0.01, -1.5, nub_h - 0.01]) cube([0.01, 3, 0.01]);
                    }
}

module lid() {
    difference() {
        union() {
            // coque du capot
            difference() {
                translate([0, 0, z_split]) linear_extrude(z_top - z_split) outer_profile();
                translate([0, 0, z_split - 1]) linear_extrude(z_lid_in - z_split + 1) inner_profile();
            }
            pill_block();
        }
        // fenêtre sur la matrice LED (membrane optionnelle conservée en haut)
        translate([led_win_x0, led_win_y0, z_lid_in - 1])
            linear_extrude(led_diffuser_t > 0 ? top_t + 1 - led_diffuser_t : top_t + 2)
                rrect(led_win, 2);
        // fente câbles d'électrodes dans la jupe +Y, ouverte vers le bas (sans support)
        translate([0, out_y + 1, 0]) rotate([90, 0, 0])
            linear_extrude(wall + 2)
                hull() {
                    translate([block_cx - slot_w / 2 + slot_r, z_slot_top - slot_r]) circle(r = slot_r);
                    translate([block_cx + slot_w / 2 - slot_r, z_slot_top - slot_r]) circle(r = slot_r);
                    translate([block_cx - slot_w / 2, z_split - 1]) square([slot_w, 0.1]);
                }
    }
}

// =============================================================================
//  Composants fantômes (contrôle visuel uniquement)
// =============================================================================
module components_base() {
    // PCB Arduino
    color("teal", 0.8)
        translate([ard_x0, ard_y0, z_pcb_bot])
            linear_extrude(ard_t) difference() {
                square([ard_l, ard_w]);
                for (h = ard_holes) translate(h) circle(d = ard_hole_d);
            }
    // USB-C
    color("silver") translate([ard_x0 - usb_overhang, ard_y0 + usb_y - usb_w / 2, z_pcb_top])
        cube([7.3 + usb_overhang, usb_w, usb_h]);
    // Jack DC (J5)
    color("dimgray") translate([ard_x0 - 1.3, ard_y0 + 3.4, z_pcb_top]) cube([13.8, 9.0, ard_comp_h]);
    // Connecteurs femelles
    color("dimgray") {
        translate([ard_x0 + 17.5, ard_y0 + 50.8 - 1.27, z_pcb_top]) cube([46, 2.54, ard_header_h]);
        translate([ard_x0 + 27.0, ard_y0 + 2.54 - 1.27, z_pcb_top]) cube([39, 2.54, ard_header_h]);
    }
    // Module ESP32-S3 (M1) et bouton reset
    color("silver") translate([ard_x0 + 1, ard_y0 + 13, z_pcb_top]) cube([17, 15.5, 3.1]);
    color("white") translate([ard_x0 + 2.0, ard_y0 + ard_w - 0.73 - 6.4, z_pcb_top]) cube([6.4, 6.4, 5]);
    // Matrice LED
    color("red") translate([ard_x0 + led_center[0] - led_size[0] / 2, ard_y0 + led_center[1] - led_size[1] / 2, z_pcb_top])
        cube([led_size[0], led_size[1], 0.8]);
    // fils OUT/GND/VCC vers l'Arduino (indicatif)
    for (cx = pill_cx, i = [-1, 0, 1]) color("orange")
        translate([cx + i * pill_pin_pitch - 0.5, pill_y0 - 0.5, z_pcb_top + ard_header_h])
            cube([1, 1, z_pill_pcb_bot - z_pcb_top - ard_header_h]);
}

module components_lid() {
    // BioAmp EXG Pill × 2 (composants vers le bas)
    for (cx = pill_cx) translate([cx, 0, 0]) {
        color("black") translate([-pill_w / 2, pill_y0, z_pill_pcb_bot])
            linear_extrude(pill_t) rrect([pill_w, pill_l], pill_r);
        color("gray") translate([-2.2, pill_y0 + 8, z_pill_pcb_bot - 1.1]) cube([4.4, 5, 1.1]);        // TL084
        color("white") translate([-jst_w / 2, pill_y1 + jst_overhang - jst_len, z_pill_pcb_bot - jst_h])
            cube([jst_w, jst_len, jst_h]);                                                             // JST PH
        color("red", 0.6) translate([-jst_w / 2 + 0.3, pill_y1 + jst_overhang, z_pill_pcb_bot - jst_h + 0.5])
            cube([jst_w - 0.6, 9, jst_h - 1.5]);                                                       // prise PHR-3
        for (i = [-1, 0, 1]) color("red", 0.6)
            translate([i * 2.0 - 0.8, pill_y1 + jst_overhang + 9, z_pill_pcb_bot - jst_h + 1.5])
                cube([1.6, cable_margin - 9 - jst_overhang + wall + 4, 1.6]);                          // 3 câbles
    }
}

// =============================================================================
//  Sélection de la vue
// =============================================================================
if (part == "base") {
    base();
} else if (part == "lid") {
    translate([0, out_y, z_top]) rotate([180, 0, 0]) lid();   // en position d'impression
} else if (part == "print") {
    base();
    translate([out_x + 10, out_y, z_top]) rotate([180, 0, 0]) lid();
} else {
    base();
    translate([0, 0, explode]) lid();
    if (show_components) {
        components_base();
        translate([0, 0, explode]) components_lid();
    }
}
