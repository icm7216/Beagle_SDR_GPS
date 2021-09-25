/* -*- c++ -*- */
/* 
 * Copyright 2015 Milen Rangelov <gat3way@gmail.com>
 * 
 * This is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 * 
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */

/*

gr-ale is written by Milen Rangelov (gat3way@gmail.com) and licensed under the GNU General Public License

Significant portions of source code were based on the LinuxALE project (under GNU License):

 * Copyright (C) 2000 - 2001 
 *   Charles Brain (chbrain@dircon.co.uk)
 *   Ilkka Toivanen (pile@aimo.kareltek.fi)

*/

#pragma once

#define NSYM                        33
#define NR                          17      // ceil(NSYM/2)
#define NR_POW2                     32      // for double indexed array addressing efficiency

#define FFT_SIZE                    64
#define HALF_FFT_SIZE               (FFT_SIZE/2)

#define SYMBOLS_PER_WORD            49
#define VOTE_BUFFER_LENGTH          48
#define NOT_WORD_SYNC               0
#define WORD_SYNC                   1
#define BITS_PER_SYMBOL             3
#define VOTE_ARRAY_LENGTH           (SYMBOLS_PER_WORD * BITS_PER_SYMBOL)
#define BAD_VOTE_THRESHOLD          25
#define SYNC_ERROR_THRESHOLD        1

#define SAMP_RATE_SPS               8000    // FFT_SIZE depends on audio sample rate
#define SYMBOL_PERIOD_MS            8       // per the ALE spec
#define SYMBOLS_PER_SEC             125     // 1 / SEC(SYMBOL_PERIOD_MS)
#define SAMPS_PER_SYMBOL            (SAMP_RATE_SPS / SYMBOLS_PER_SEC)

#define PI                          M_PI

#include "decode_ff.h"
#include "caudioresample.h"     // from DRM/dream/resample

#include <fftw3.h>

#ifdef STANDALONE_TEST
    double ext_update_get_sample_rateHz(int rx_chan) { return 0; }
    int ext_send_msg(int rx_chan, bool debug, const char *msg, ...) { return 0; }
#else
    #include "ext.h"
#endif

//#define ALE_REAL double
#define ALE_REAL float

namespace ale {

    typedef struct {
        ALE_REAL real;
        ALE_REAL imag;
    } Complex;

    typedef struct {
        cmd_e cmd;
        u4_t data;
        char cmd_s[256];
    } cmd_t;
    
    
    class decode_ff_impl {

    private:
        int         inbuf_i;
        ALE_REAL    inbuf[HALF_FFT_SIZE];
        
        ALE_REAL    fft_cs_twiddle[FFT_SIZE];
        ALE_REAL    fft_ss_twiddle[FFT_SIZE];
        Complex     fft_out[HALF_FFT_SIZE];
        ALE_REAL    fft_mag[HALF_FFT_SIZE];
        
        fftwf_plan    dft_plan;
        fftwf_complex dft_in[sizeof(fftwf_complex) * FFT_SIZE];
        fftwf_complex dft_out[sizeof(fftwf_complex) * FFT_SIZE];

        ALE_REAL    fft_history[FFT_SIZE];
        int         fft_history_offset;

        // sync information
        ALE_REAL    mag_sum[NR_POW2][FFT_SIZE];
        //ALE_REAL    mag_history[NR_POW2][FFT_SIZE][SYMBOLS_PER_WORD];
        int         mag_history_offset;
        int         word_sync[NR];

        // worker data
        //int started[NR];    // if other than DATA has arrived
        int bits[NR][VOTE_ARRAY_LENGTH];
        int input_buffer_pos[NR];
        int word_sync_position[NR];

        // protocol data
        char thru[4];
        char to[4];
        char twas[4];
        char from[4];
        char tis[4];

        char data[4];
        char prev_data2[4];
        char rep[4];

        char cmd[4];

        #define N_CUR 256
        char current[N_CUR];
        char current2[N_CUR];
        int in_cmd, binary;
        bool ascii_38_ok, ascii_64_ok, ascii_nl_ok;
        
        cmd_t cmds[16];
        int cmd_cnt;

        int ber[NR];
        int lastber;
        int bestpos;
        int inew;

        int ithru;
        int ito;
        int itwas;
        int ifrom;
        int itis;

        int idata;
        int irep;

        int icmd;
        
	    char s1[4], s2[4];
	    int ito2, itwas2, ifrom2, itis2, idata2, irep2, icmd2;
	    char to2[4], twas2[4], from2[4], tis2[4], data2[4], rep2[4], cmd2[4];
	    int bestber;

        int state;
        int state_count;
        int stage_num;

        int last_symbol[NR];
        int last_sync_position[NR];
        int nsym;
        int sample_count;
        int activity_cnt;
        int active;
        int cmd_freq_Hz;
        int secs, timer_samps;
        double frequency;
        
        int dsp;
        bool log_buf_empty;
        char log_buf[256];
        char dpf_buf[256];
        char locked_msg[256];

        #define N_SAMP_BUF 1024
        #ifdef STANDALONE_TEST
            u2_t sbuf[N_SAMP_BUF];
            float fbuf[N_SAMP_BUF];
        #endif
        
        int rx_chan;
        bool use_UTC;
        bool notify;
        
        u4_t golay_encode(u4_t data);
        u4_t golay_decode(u4_t code, int *errors);
        int decode_word(u4_t word, int nr, int berw, int caller);
        u4_t modem_de_interleave_and_fec(int *input, int *errors);
        int modem_new_symbol(int sym, int nr);
        void log(char *current, char *current2, int state, int ber, const char *from);
        void cprintf_msg(int cond_d);
        void dprintf_msg();
        void do_modem1(bool eof = false);
        void do_modem2();
    
    protected:
        // resampler
        CAudioResample *ResampleObj;
        CVector<_REAL> vecTempResBufIn;
        CVector<_REAL> vecTempResBufOut;

    public:
        // options
        bool calc_mag;

        decode_ff_impl();
        ~decode_ff_impl();
        void modem_init(int rx_chan, bool use_new_resampler, float f_srate, int n_samps, bool use_UTC = true);
        void modem_reset();
        void set_display(int display);
        void set_freq(double freq);
        void run_standalone(int fileno, int offset);
        void do_modem(float *sample, int length);
        void do_modem_resampled(short *sample, int length);
    };

} // namespace ale
