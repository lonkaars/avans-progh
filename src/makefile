pixeldata-ball.vhd: pixeldata-ball-top.vhd bitmap-ball.vhd pixeldata-ball-bottom.vhd
	cat $^ > $@

bitmap-ball.vhd: bitmap-ball.py
	python3 $< > $@

