
    

MODULE Pizza_slicer
    PERS tooldata Marker:=[TRUE,[[0,0,135],[0,0,1,0]],[0.1,[0,0,100],[1,0,0,0],0,0,0]];
    
    CONST num Above_distance := 50;
    VAR num Piza_width_max := 29;
    VAR num Number_of_slices_max := 24;
    VAR speeddata VFast := v1500;
    VAR speeddata VMedium := v500;
    VAR speeddata VSlow := v100;
    VAR zonedata ZPresize := fine;
    VAR zonedata ZCoarse := z100;
    
    VAR num Piza_width := 0;
    VAR num Number_of_slices := 0;
	CONST robtarget Center_Above := [[424,0,Above_distance],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Center := [[424,0,-25],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget Min_target := [[280,0,-25],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget Max_target := [[568,0,-25],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget PizzaCorner1;
    VAR robtarget PizzaCorner2;
    VAR robtarget PizzaCorner3;
    VAR robtarget PizzaCorner4;
    VAR robtarget PizzaCorner1_Above;
    
    PROC main()
        Asking;
        DrawPiza;
    ENDPROC
    
    PROC Asking()
        ask_width_pizza:
        TPReadNum Piza_width, "How many cm is your pizza?";
        IF Piza_width <= 0 OR Piza_width > Piza_width_max THEN
            TPWrite "Pizza's larger then ", \Num := Piza_width_max;
            TPWrite "can not be sliced. Fill in a number between 0 and 30";
            GOTO ask_width_pizza;
        ENDIF
        
        Piza_width := Piza_width * 10;
        PizzaCorner1 := [[424 + (Piza_width / 2),                0, -25],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        PizzaCorner2 := [[424,                    (Piza_width / 2), -25],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        PizzaCorner3 := [[424 - (Piza_width / 2),                0, -25],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        PizzaCorner4 := [[424,                   -(Piza_width / 2), -25],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        PizzaCorner1_Above := [[424 + (Piza_width / 2),                0, Above_distance],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        
        ask_number_of_slices:
        TPReadNum Number_of_slices, "How many slices did you want?";
        IF Number_of_slices <= 1 OR Number_of_slices > Number_of_slices_max THEN
            TPWrite "Number should be between 0 and ", \Num := Number_of_slices_max;
            GOTO ask_number_of_slices;
        ENDIF
    ENDPROC
    
    PROC DrawPiza()
        VAR num end_x;
        VAR num end_y;
        VAR num current_angle := 0;
        VAR num angle_slice;
        VAR robtarget Slice_target;
        VAR robtarget Slice_target_above;
        angle_slice := 360 / Number_of_slices;
        
        MoveJ PizzaCorner1_Above, VFast, ZCoarse, Marker\WObj:=wobj0;
        MoveL PizzaCorner1, VSlow, ZPresize, Marker\WObj:=wobj0;
        MoveC PizzaCorner2, PizzaCorner3, VSlow, ZPresize, Marker\WObj:=wobj0;
        MoveC PizzaCorner4, PizzaCorner1, VSlow, ZPresize, Marker\WObj:=wobj0;
        MoveJ PizzaCorner1_Above, VFast, ZCoarse, Marker\WObj:=wobj0;
        
        MoveJ Center_Above, VFast, z100, Marker\WObj:=wobj0;
        
        FOR i FROM 0 TO (Number_of_slices-1) DO
            end_x := (Piza_width / 2) * Sin(current_angle);
            end_y := (Piza_width / 2) * Cos(current_angle);
            Slice_target := [[424 + end_x, end_y, -25],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
            Slice_target_above := [[424 + end_x, end_y, Above_distance],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
            MoveL Center, VSlow, ZPresize, Marker\WObj:=wobj0;
            MoveL Slice_target, VMedium, ZPresize, Marker\WObj:=wobj0;
            MoveJ Slice_target_above, VFast, ZPresize, Marker\WObj:=wobj0;
            MoveJ Center_Above, VFast, ZCoarse, Marker\WObj:=wobj0;
            current_angle := current_angle + angle_slice;
        ENDFOR
    ENDPROC
ENDMODULE
