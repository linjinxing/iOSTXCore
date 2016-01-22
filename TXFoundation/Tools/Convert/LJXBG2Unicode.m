//
//  BG2Unicode.m
//  eCook
//
//  Created by apple on 09-12-30.
//  Copyright 2009 Shenzhen Palmedia technology co., ltd. All rights reserved.
//

#import "LJXBG2Unicode.h"

#include <iconv.h>

static int code_convert(char *from_charset, char *to_charset, const char *inbuf, size_t inlen, char *outbuf, size_t outlen) {
    iconv_t cd = NULL;
	
    cd = iconv_open(to_charset, from_charset);
    if(!cd)
        return -1;
	
    memset(outbuf, 0, outlen);
    if(iconv(cd, (char**)&inbuf, &inlen, &outbuf, &outlen) == -1)
        return -1;
	
    iconv_close(cd);
    return 0;
}

int u2g(const char *inbuf, size_t inlen, char *outbuf, size_t outlen) {
    return code_convert("utf-8", "gb2312", inbuf, inlen, outbuf, outlen);
}

int g2u(const char *inbuf, size_t inlen, char *outbuf,size_t outlen) {
    return code_convert("gb2312", "utf-8", inbuf, inlen, outbuf, outlen);
}
