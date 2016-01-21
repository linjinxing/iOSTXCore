//
//  urldecodeutf8gbk.c
//  IMPlayer
//
//  Copyright (c) 2012 LJX. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LJXDebug.h"
#include "LJXurldecodeutf8gbk.h"

// ===== char utility functions. =====

unsigned char get_onebyte_from_twochar( char highchar, char lowchar );

int UrlDecodeAnsiCharOnly(char *str, int len )
{
	char *dest = str;
	char *data = str;
	
	while( len-- )
	{
		if (*data == '%' && len >= 2 &&
			isxdigit((int) *(data + 1)) && isxdigit((int) *(data + 2)))
		{
			char ch0 = *(data+1);
			char ch1 = *(data+2);
			unsigned char chResult = get_onebyte_from_twochar( ch0, ch1 );
			
			if( chResult >= 0x20 && chResult <= 0x7F )
			{
				*dest = chResult;
				
				data += 2;
				len -= 2;
			}
			else
			{
				*dest = *data;
			}
		}
		else
		{
			*dest = *data;
		}
		
		data++;        
		dest++;        
	}
	*dest = '\0';
	
	return dest - str;
}

int UrlDecodeUsingUTF8(char *str, int len )
{
	char *dest = str;
	char *data = str;
	
	while (len--)
	{
		
		if (*data == '+')
		{
			*dest = ' ';            
		}
		else if( *data == '\\' && len>=1 && *(data+1) == '\\' )
		{
			// skip double "\\"
			// http://www.999271.com/player/player4671.html?4671-0-0
			// [\u5077\u6708\u60C5][dvd-rmvb][\u4E2D\u5B57][\u624E\u5C14\u66FC\u91D1\u4F5C\u54C1].rmvb
			dest--;
		}
		else if (*data == '%' && len >= 2 &&
				 isxdigit((int) *(data + 1)) && isxdigit((int) *(data + 2)))
		{
			char ch0 = *(data+1);
			char ch1 = *(data+2);
			*dest = get_onebyte_from_twochar( ch0, ch1 );
			
			data += 2;            
			len -= 2;            
		}
		else if (( *data == '%' || *data == '\\' ) && len >= 5 &&
				 ( *(data+1) == 'u' ||  *(data+1) == 'U' ) &&
				 isxdigit((int) *(data + 2)) && isxdigit((int) *(data + 3)) &&
				 isxdigit((int) *(data + 4)) && isxdigit((int) *(data + 5)) )
		{
			// Non-standard implementations
			//
			// There exists a non-standard encoding for Unicode characters: %uxxxx, where xxxx is a Unicode value
			// represented as four hexadecimal digits. This behavior is not specified by any RFC and has been rejected
			// by the W3C. The third edition of ECMA-262 still includes an escape(string) function that uses this
			// syntax, but also an encodeURI(uri) function that converts to UTF-8 and percent-encodes each octet.
			char ch0 = *(data+2);
			char ch1 = *(data+3);
			char ch2 = *(data+4);
			char ch3 = *(data+5);
			
			char chBuffer[6];
			chBuffer[0] = get_onebyte_from_twochar( ch0, ch1 );
			chBuffer[1] = get_onebyte_from_twochar( ch2, ch3 );
			chBuffer[2] = 0;
			chBuffer[3] = 0;
			chBuffer[4] = 0;
			chBuffer[5] = 0;
			
			NSString* strOneWord = [NSString stringWithCString:chBuffer encoding:NSUnicodeStringEncoding];
			const char* pszUtf8Word = [strOneWord cStringUsingEncoding:NSUTF8StringEncoding];
			
			// the length of NSUTF8StringEncoding maybe 2 bytes or 3 bytes!!!!
			while( *pszUtf8Word )
			{
				*dest = *pszUtf8Word++;
				dest++;
			}
			--dest;
			
			data += 5;
			len -= 5;
		}
		else
		{
			if( '%' == *data && 'U' == *(data + 1) /*&& 'f' == *(data + 2) && 'f' == *(data + 3)*/ )
			{
				LJXFoundationLog( "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" );
				for(unsigned int i=0; i<18; ++i)
				{
					LJXFoundationLog( "%02x", (unsigned char)(*(data+i)) );
				}
				LJXFoundationLog( "\n" );
				LJXFoundationLog( "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" );
			}
			
			*dest = *data;            
		}
		
		data++;        
		dest++;        
	}
	*dest = '\0';
	
	return dest - str;
}

int UrlDecodeUsingGBK(char *str, int len )
{
	char *dest = str;
	char *data = str;
	
	while (len--)
	{
		//////  尝试进行gbk转换
//        if (2 == sizeof(unsigned short)) {
//            unsigned short hz = 0; 
//            if (hz >= 0x8140 && hz <= 0xfefe) {
//                
//            }
//        }
//        else if (2 == sizeof(int)) 
//        {    
//            unsigned int hz = 0;
//            if (hz >= 0x8140 && hz <= 0xfefe) {
//                
//            }
//        }        
        
		if (*data == '+')
		{
			*dest = ' ';            
		}
		else if( *data == '\\' && len>=1 && *(data+1) == '\\' )
		{
			// skip double "\\"
			// http://www.999271.com/player/player4671.html?4671-0-0
			// [\u5077\u6708\u60C5][dvd-rmvb][\u4E2D\u5B57][\u624E\u5C14\u66FC\u91D1\u4F5C\u54C1].rmvb
			dest--;
		}
		else if( *data == '%' && len >= 5 &&
				isxdigit((int) *(data + 1)) && isxdigit((int) *(data + 2)) &&
				*(data+3) == '%' &&
				isxdigit((int) *(data + 4)) && isxdigit((int) *(data + 5)) /*&&
																			( ( (unsigned char)(*(data + 1)) >= '8' ) && ((unsigned char)(*(data + 4)) >= '8' ) )*/ )
		{
			// '%7C' exception: %7C%E8%80%81%E7%94%B7%E5%AD%A9_%E8%80%81%E7%94%B7%E5%AD%A9.rmvb
			// %2F634882524%7C78073B4DABDA6398856DA9EA3005E4B5FF0ED160%7C%E8%80%81%E7%94%B7%E5%AD%A9_%E8%80%81%E7%94%B7%E5%AD%A9.rmvb%7C
			
			char ch0 = *(data+1);
			char ch1 = *(data+2);
			char ch2 = *(data+4);
			char ch3 = *(data+5);
			
			unsigned char szBuffer[5];
			szBuffer[0] = get_onebyte_from_twochar( ch0, ch1 );
			szBuffer[1] = get_onebyte_from_twochar( ch2, ch3 );
			szBuffer[2] = 0;
			szBuffer[3] = 0;
			szBuffer[4] = 0;
			
			if( szBuffer[0] >= 0x80 && szBuffer[1]>= 0x80 )
			{
//				if( 0x7C == szBuffer[0] )
//				{
//					int nnn = 0;
//				}
				
				// look like GBK encoding....
				NSData *newData = [NSData dataWithBytes:szBuffer length:2];
				NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
				NSString *strAsGBK = [[NSString alloc] initWithData:newData encoding:enc];
				
				const char* pszUtf8Word = [strAsGBK cStringUsingEncoding:NSUTF8StringEncoding];
				
				if( pszUtf8Word )
				{
					while( *pszUtf8Word )
					{
						*dest = *pszUtf8Word;
						pszUtf8Word++;
						dest++;
					}
					dest--;
				}
				else
				{
					*dest = '_';
					LJXFoundationLog( "WHY strAsGBK to char* pszUtf8Word FALSE???\n" );
				}
				
				data += 5;
				len -= 5;
				
			}
			else
			{
//				if( 0x7C == szBuffer[0] )
//				{
//					int nnn = 0;
//				}
				
				*dest = szBuffer[0];
				//dest++;
				//*dest = szBuffer[1];
				
				//data += 5;
				//len -= 5;
				data += 2;
				len -= 2;
			}
			
		}
		else if (*data == '%' && len >= 2 &&
				 isxdigit((int) *(data + 1)) && isxdigit((int) *(data + 2)))
		{
			char ch0 = *(data+1);
			char ch1 = *(data+2);
			*dest = get_onebyte_from_twochar( ch0, ch1 );
			
			data += 2;
			len -= 2;
		}
		else if ((*data == '%' || *data == '\\' ) && len >= 5 &&
				 ( *(data+1) == 'u' ||  *(data+1) == 'U' ) &&
				 isxdigit((int) *(data + 2)) && isxdigit((int) *(data + 3)) &&
				 isxdigit((int) *(data + 4)) && isxdigit((int) *(data + 5)) )
		{
			// Non-standard implementations
			//
			// There exists a non-standard encoding for Unicode characters: %uxxxx, where xxxx is a Unicode value
			// represented as four hexadecimal digits. This behavior is not specified by any RFC and has been rejected
			// by the W3C. The third edition of ECMA-262 still includes an escape(string) function that uses this
			// syntax, but also an encodeURI(uri) function that converts to UTF-8 and percent-encodes each octet.
			char ch0 = *(data+2);
			char ch1 = *(data+3);
			char ch2 = *(data+4);
			char ch3 = *(data+5);
			
			char chBuffer[6];
			chBuffer[0] = get_onebyte_from_twochar( ch0, ch1 );
			chBuffer[1] = get_onebyte_from_twochar( ch2, ch3 );
			chBuffer[2] = 0;
			chBuffer[3] = 0;
			chBuffer[4] = 0;
			chBuffer[5] = 0;
			
			NSString* strOneWord = [NSString stringWithCString:chBuffer encoding:NSUnicodeStringEncoding];
			const char* pszUtf8Word = [strOneWord cStringUsingEncoding:NSUTF8StringEncoding];
			
			// the length of NSUTF8StringEncoding maybe 2 bytes or 3 bytes!!!!
			while( *pszUtf8Word )
			{
				*dest = *pszUtf8Word++;
				dest++;
			}
			--dest;
			
			data += 5;
			len -= 5;
		}
		else
		{
			*dest = *data;            
		}
		
		data++;        
		dest++;        
	}
	*dest = '\0';
	
	return dest - str;
}

unsigned char get_onebyte_from_twochar( char highchar, char lowchar )
{
	unsigned char chRet = '_';
	if( ( (highchar>='0' && highchar<='9') ||
		 (highchar>='a' && highchar<='z') ||
		 (highchar>='A' && highchar<='Z') ) && 
	   ( (lowchar>='0' && lowchar<='9') ||
		(lowchar>='a' && lowchar<='z') ||
		(lowchar>='A' && lowchar<='Z') ) )
	{
		if(highchar>='0' && highchar<='9')
		{
			chRet = ( ( (highchar-'0') << 4 ) & 0xF0 );
		}
		else if(highchar>='a' && highchar<='z')
		{
			chRet = ( ( (highchar-'a'+10) << 4 ) & 0xF0 );
		}
		else // highchar>='A' && highchar<='Z'
		{
			chRet = ( ( (highchar-'A'+10) << 4 ) & 0xF0 );
		}
		
		if(lowchar>='0' && lowchar<='9')
		{
			chRet += ( (lowchar-'0') & 0x0F );
		}
		else if(lowchar>='a' && lowchar<='z')
		{
			chRet += ( (lowchar-'a'+10 ) & 0x0F );
		}
		else // lowchar>='A' && lowchar<='Z'
		{
			chRet += ( (lowchar-'A'+10) & 0x0F );
		}
	}
	
	return chRet;
}
// ===== char utility functions. =====
