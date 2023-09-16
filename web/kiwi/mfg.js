// Copyright (c) 2016-2023 John Seamons, ZL4VO/KF6VO

var mfg = {
   ver_maj: 0,
   ver_min: 0,
   
   serno: 0,
   next_serno: -1,
   
   model_i: 1,    // KiwiSDR 2
   model: 2,
   cur_model: -1,
   MODEL_BIAS: 1,
   model_s: [ 'KiwiSDR 1', 'KiwiSDR 2' ],
   
   __last__: null
};

function mfg_main()
{
}

function kiwi_ws_open(conn_type, cb, cbp)
{
	return open_websocket(conn_type, cb, cbp, null, mfg_recv);
}

function mfg_draw()
{
	var s =
		w3_div('',
		   '<h4><strong>Manufacturing interface</strong>&nbsp;&nbsp;' +
			'<small>(software version v'+ mfg.ver_maj +'.'+ mfg.ver_min +')</small></h4>'
		);
	
	/*
	s += mfg.ver_maj?
		w3_div('w3-text-css-lime', '<h2>OKAY to make customer SD cards using this.</h2>') :
		w3_div('w3-text-red"', '<h2>WARNING: Use for testing only!<br>Do not make customer SD cards with this yet.</h2>');
   */
   
	s +=
	   //w3_text('id-mfg-ee-status') +
	   
		w3_col_percent('w3-margin-top w3-valign/w3-hcenter',
         w3_divs('/w3-block w3-hcenter',
            w3_text('id-ee-status w3-bold', 'EEPROM data:'),
            w3_div('id-ee-write w3-btn w3-round-large w3-margin-T-8||onclick="mfg_ee_write()"')
         ), 40,
         w3_div('', '&nbsp;'), 20,
			w3_div('id-power-off w3-btn w3-round-large|background-color:fuchsia||onclick="mfg_power_off()"'), 40
		) +
		'<br>' +

		w3_col_percent('/w3-hcenter',
			w3_div('id-seq-override w3-btn w3-round-large w3-yellow||onclick="mfg_seq_override()"'), 40,
			'<input id="id-seq-input" class="w3-input w3-border w3-width-auto w3-hover-shadow w3-hidden" type="text" size=9 onchange="mfg_seq_set()">', 20,
         w3_select('', 'Model:', '', 'mfg.model_i', mfg.model_i, mfg.model_s, 'mfg_model_cb'), 40
		) +
		'<hr>' +

		w3_third('', '',
			w3_div('id-sd-write w3-btn w3-round-large w3-aqua||onclick="mfg_sd_write()"'),

			w3_div('',
            w3_div('w3-progress-container w3-round-large w3-white w3-show-inline-block',
               w3_div('id-progress w3-progressbar w3-round-large w3-light-green w3-width-zero',
                  w3_div('id-progress-text w3-container w3-text-black')
               )
            ),
            
            w3_div('w3-margin-T-8',
               w3_div('id-progress-time w3-show-inline-block'),
               w3_div('id-progress-icon w3-show-inline-block w3-margin-left')
            )
         ),

			w3_div('id-sd-status class-sd-status')
		) +
		'<hr>' +

		w3_div('id-output-msg class-mfg-status w3-scroll-down w3-small');
	
	var el = w3_innerHTML('id-mfg',
	   w3_div('w3-container w3-section w3-dark-grey w3-half',
	      s
	   )
	);
	el.style.top = el.style.left = '10px';

	var el2 = w3_innerHTML('id-sd-write', 'click to write<br>micro-SD card');

	el2 = w3_innerHTML('id-power-off', 'click to halt<br>and power off');

	w3_show_block(el);
	
	//setTimeout(function() { setInterval(status_periodic, 5000); }, 1000);
}

function mfg_model_cb(path, idx, first)
{
   mfg.model_i = +idx;
   mfg.model = mfg.model_i + mfg.MODEL_BIAS;
   mfg_set_button_text();
}

function mfg_recv(data)
{
	var stringData = arrayBufferToString(data);
	params = stringData.substring(4).split(" ");

	for (var i=0; i < params.length; i++) {
		param = params[i].split("=");
		
		switch (param[0]) {
			case "ver_maj":
				mfg.ver_maj = parseFloat(param[1]);
				break;

			case "ver_min":
				mfg.ver_min = parseFloat(param[1]);
				mfg_draw();
				break;

			case "serno":
				mfg.serno = parseFloat(param[1]);
				console.log("MFG next_serno="+ mfg.next_serno + " serno="+ mfg.serno);
				
				mfg_set_button_text();

				w3_innerHTML('id-seq-override', 'next serial number = #'+ mfg.next_serno +'<br>click to override');
				el = w3_remove('id-seq-input', 'w3-visible');
				el.value = mfg.next_serno;
			   mfg_set_status();
				break;
			
			case "next_serno":
				mfg.next_serno = parseFloat(param[1]);
				break;

			case "model":
			   mfg.cur_model = parseFloat(param[1]);
			   mfg_set_status();
				console.log("MFG cur_model="+ mfg.cur_model);
			   break;

			case "microSD_done":
				mfg_sd_write_done(parseFloat(param[1]));
				break;

			default:
				console.log('MFG UNKNOWN: '+ param[0] +'='+ param[1]);
				break;
		}
	}
}

function mfg_set_status()
{
   w3_innerHTML('id-ee-status', 'EEPROM data: KiwiSDR '+ mfg.cur_model +', #'+ mfg.serno);
}

function mfg_set_button_text()
{
   var button_text;
   
   if (mfg.serno <= 0) {		// write serno = 0 to force invalid for testing
      //button_text = 'invalid, click to write EEPROM<br>with next serial number: '+ mfg.next_serno +
      //   '<br>and model: KiwiSDR '+ mfg.model;
      button_text = 'invalid, click to write EEPROM with:<br>model KiwiSDR '+ mfg.model +', #'+ mfg.next_serno;
      button_color = 'red';
   } else {
      //button_text = 'valid, serial number = '+ mfg.serno +'<br>click to change to '+ mfg.next_serno +
      //   '<br>and model: KiwiSDR '+ mfg.model;
      button_text = 'valid, click to change EEPROM to:<br>model KiwiSDR '+ mfg.model +', #'+ mfg.next_serno;
      button_color = '#4CAF50';		// w3-green
   }
   
   var el = w3_innerHTML('id-ee-write', button_text);
   w3_background_color(el, button_color);
}

function mfg_ee_write()
{
	ext_send("SET write model="+ mfg.model);
}

function mfg_seq_override()
{
	w3_add('id-seq-input', 'w3-visible');
}

function mfg_seq_set()
{
	mfg.next_serno = parseFloat(w3_el('id-seq-input').value).toFixed(0);
	if (mfg.next_serno >= 0 && mfg.next_serno <= 9999) {
		ext_send("SET set_serno="+ mfg.next_serno);
		mfg_set_button_text();
	}
}

var sd_progress, sd_progress_max = 4*60;		// measured estimate -- in secs (varies with SD card write speed)
var mfg_sd_interval;
var refresh_icon = '<i class="fa fa-refresh fa-spin" style="font-size:24px"></i>';

function mfg_sd_write()
{
	var el = w3_innerHTML('id-sd-write', 'writing the<br>micro-SD card...');
	w3_add(el, 'w3-override-yellow');

	el = w3_innerHTML('id-sd-status', 'writing micro-SD card...');
	w3_color(el, 'white');

	w3_el('id-progress-text').innerHTML = w3_el('id-progress').style.width = '0%';

	sd_progress = -1;
	mfg_sd_progress();
	mfg_sd_interval = setInterval(mfg_sd_progress, 1000);

	w3_innerHTML('id-progress-icon', refresh_icon);

	ext_send("SET microSD_write");
}

function mfg_sd_progress()
{
	sd_progress++;
	var pct = ((sd_progress / sd_progress_max) * 100).toFixed(0);
	if (pct <= 95) {	// stall updates until we actually finish in case SD is writing slowly
		w3_el('id-progress-text').innerHTML = w3_el('id-progress').style.width = pct +'%';
	}
	var secs = (sd_progress % 60).toFixed(0).leadingZeros(2);
	var mins = Math.floor(sd_progress / 60).toFixed(0);
	w3_innerHTML('id-progress-time', mins +':'+ secs);
}

function mfg_sd_write_done(err)
{
	var el = w3_innerHTML('id-sd-write', 'click to write<br>micro-SD card');
	w3_remove(el, 'w3-override-yellow');

	var msg = err? ('FAILED error '+ err.toString()) : 'WORKED';
	if (err == 1) msg += '<br>No SD card inserted?';
	if (err == 15) msg += '<br>rsync I/O error';
	var el = w3_innerHTML('id-sd-status', msg);
	w3_color(el, err? 'red':'lime');

	if (!err) {
		// force to max in case we never made it during updates
		w3_el('id-progress-text').innerHTML = w3_el('id-progress').style.width = '100%';
	}
	kiwi_clearInterval(mfg_sd_interval);
	w3_innerHTML('id-progress-icon', '');
}

function mfg_power_off()
{
	var el = w3_innerHTML('id-power-off', 'halting and<br>powering off...');
	w3_background_color(el, 'red');
	ext_send("SET mfg_power_off");
}
