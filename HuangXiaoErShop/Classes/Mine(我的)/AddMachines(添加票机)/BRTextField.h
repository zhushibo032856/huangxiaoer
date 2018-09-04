

#import <UIKit/UIKit.h>

typedef void(^BRTapAcitonBlock)(void);
typedef void(^BREndEditBlock)(NSString *text);

@interface BRTextField : UITextField
/** textField 的点击回调 */
@property (nonatomic, copy) BRTapAcitonBlock tapAcitonBlock;
/** textField 结束编辑的回调 */
@property (nonatomic, copy) BREndEditBlock endEditBlock;

@end
