pixeldata-ball.vhd: pixeldata-ball-top.vhd bitmap-ball.vhd pixeldata-ball-bottom.vhd
	cat $^ > $@

bitmap-ball.vhd: ball.png
	python3 bitmap-ball.py $< > $@

