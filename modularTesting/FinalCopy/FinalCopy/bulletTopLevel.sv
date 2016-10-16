
module  BulletTopLevel
(
				input Reset, VS,  // frame_clk is vertical sync
				input shootingEnable, collision, direction,
				input[3:0] keycode,
				input [9:0]  PlayerX, PlayerY, PlayerHeight, PlayerWidth, DrawX, DrawY,
				
				
				output logic bulletOn1, bulletOn2, bulletOn3, bulletOn4, bulletOn5, bulletOn6
);
    

Bullet bullet1(.*, .bullet_on(bulletOn1));
/*
Bullet bullet2(.*, .bullet_on(bulletOn2));
Bullet bullet3(.*, .bullet_on(bulletOn3));
Bullet bullet4(.*, .bullet_on(bulletOn4));
Bullet bullet5(.*, .bullet_on(bulletOn5));
Bullet bullet6(.*, .bullet_on(bulletOn6));	
*/

endmodule
