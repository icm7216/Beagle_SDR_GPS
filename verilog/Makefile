V_SRC_DIR = /media/sf_shared

all:
	@echo "no default"
	
cv:
	@echo "you probably want to use \"make cv2\" here"

# command to "copy verilog" from KiwiSDR distribution into our build directory
# designed to complement the "make cv" command run in the KiwiSDR server build directory
cv2:
	rsync -av --delete --exclude .DS_Store $(V_SRC_DIR)/KiwiSDR/ .
	rsync -av --delete --exclude .DS_Store $(V_SRC_DIR)/KiwiSDR.ip/ ../import_ip

cb:
	cp ~/verilog/KiwiSDR/KiwiSDR.runs/impl_1/KiwiSDR.bit $(V_SRC_DIR)

cm:
	cp kiwi_map.mrp kiwi_map_mrp.html $(V_SRC_DIR)
	cp KiwiSDR.syr kiwi_syr.html $(V_SRC_DIR)
	cp KiwiSDR.twr kiwi_twr.html $(V_SRC_DIR)
	cp KiwiSDR.twx $(V_SRC_DIR)

cp:
	cp KiwiSDR.pwr $(V_SRC_DIR)

clean:
