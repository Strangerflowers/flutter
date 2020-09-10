import 'package:bid/common/log_utils.dart';
import 'package:bid/config/config_reader.dart';

abstract class ServiceUrlHolder {
  static String TAG = "ServiceUrlHolder";

  static void initialize() {
    String osapiUrl = ConfigReader.getAppOsApiUrl();
    String apiUrl = ConfigReader.getAppApiUrl();
    ServiceUrlMapper.urlMapper.forEach(
        (key, value) => ServiceUrlMapper.urlMapper[key] = osapiUrl + value);
    ServiceUrlMapper.customizeUrlMapper.forEach(
        (key, value) => ServiceUrlMapper.urlMapper[key] = apiUrl + value);
    ServiceUrlMapper.thirdUrlMapper
        .forEach((key, value) => ServiceUrlMapper.urlMapper[key] = value);
  }

  static String getUrl(String key) {
    return ServiceUrlMapper.urlMapper[key];
  }
}

class ServiceUrlMapper {
  static String updateServiceUrl = 'http://api-dev.gtland.cn';

  /// 第三方固定url地址
  static Map<String, String> thirdUrlMapper = {
    "getKey": 'https://up-z2.qbox.me/',
  };

  /// 公司其他接口定义，例如 http://api-xxx.gtland.cn 需要进行环境切换
  static Map<String, String> customizeUrlMapper = {
    'getpictrueToken': '/kernel-comm/api/qiniu/getToken', //获取请七牛云token
  };

  /// 主要接口地址定义, http://osapi-xxx.gtland.cn  需要进行环境切换
  static Map<String, String> urlMapper = {
    'login': '/os_kernel_authcctr/app/authcctr/authc/tgt/login', // 通过账号登录
    'getToken': '/os_kernel_authcctr/app/authc/token/getAndSetTime', //获取token
    'sendResetPwdCaptcha':
        '/os_kernel_userorgctr/app/user/sendLoginCaptcha', //登录获取验证码
    'sendRegCaptcha':
        '/os_kernel_userorgctr/app/user/sendRegCaptcha', //注册获取验证码的话访问用户中心的
    "register": '/os_kernel_bid/app/suppliers/register', //注册接口
    'verifyRegCheckCode':
        '/os_kernel_userorgctr/app/user/verifyRegCheckCode', //登录校验验证码
    'checkAuditStatus':
        '/os_kernel_bid/app/suppliers/user/info', //查看返回的auditStatus的状态来判断跳转到哪个页面
    'getCategory': '/os_kernel_bid/mall/category', //获取供应商类型

    'quotationQueryPage':
        '/os_kernel_bid/mp/purchase/quotation/queryPage', //报价列表查询
    'quotationDetail': '/os_kernel_bid/mp/purchase/quotation/info', //报价单详情
    'quotationDetailPlan':
        '/os_kernel_bid/mp/purchase/quotation/demand', //报价单查询所属的采购计划单详情App
    "goodsList": '/os_kernel_bid/goods/list', //商品库列表
    'goodsDetail': '/os_kernel_bid/goods/info/1', //获取商品详情(包括spu、sku规格信息)
    'listDemand': '/os_kernel_bid/app/suppliers/listDemand', //供应商app-采购-需求列表
    "demandDetail":
        '/os_kernel_bid/app/suppliers/demandDetail', //供应商app-采购-需求详情
    'soQueryPage': '/os_kernel_bid/mp/bid/suborder/soQueryPage', //销售订单分页查询(列表)
    'queryById': '/os_kernel_bid/mp/bid/suborder/queryById', //销售订单详情查询
    'queryItemById': '/os_kernel_bid/mp/bid/suborder/queryItemById', //添加发货商品展示
    'dispatchAdd': '/os_kernel_bid/mp/bid/dispatch/add', //添加发货安排
    'confirm': '/os_kernel_bid/mp/bid/dispatch/confirm', //确认发货安排
    'showDispatchProduct':
        '/os_kernel_bid/mp/bid/dispatch/showDispatchProduct', //查询发货单商品信息
    'update': '/os_kernel_bid/mp/bid/dispatch/update', //修改发货安排
    'look': '/os_kernel_bid/mp/bid/dispatch/queryById', //查询发货单详细信息
    'quoteNow': '/os_kernel_bid/app/suppliers/quoteNow', //供应商app-立即报价
    'selectGoodsByProductId':
        '/os_kernel_bid/app/suppliers/selectGoodsByProductId', //供应商app-供应商选择报价产品
    'createDemandQuotation':
        '/os_kernel_bid/app/suppliers/createDemandQuotation', //提交报价
    'getWithdrawAddress': '/os_kernel_bid/app/address/queryPage', // 个人中心-退货地址
    'getCertificationInfo':
        '/os_kernel_bid/app/suppliers/user/info', // 个人中心-认证资料
    'offline': '/os_kernel_bid/goods/offline', //下架商品
    'online': '/os_kernel_bid/goods/online', //上架商品
    'suppliersUpdate': '/os_kernel_bid/app/suppliers/user/update', //更新供应商数据
    'getAddress': '/os_kernel_appsysctr/app/district/loadDistrict', //获取地址
    'getContactInfo': '/os_kernel_bid/app/contacts/queryPage', // 个人中心-联系信息
    "getContactInfoById": '/os_kernel_bid/app/contacts/info', //查询联系人信息
    "editContactInfo": '/os_kernel_bid/app/contacts/update', // 编辑联系人
    "saveContactInfo": '/os_kernel_bid/app/contacts/save', // 新增联系人
    'saveAddress': '/os_kernel_bid/app/address/save', //新增退货地址
    'updateAddress': '/os_kernel_bid/app/address/update', //编辑退货地址
    'showEdit': '/os_kernel_bid/app/address/info', //回显地址
    "getModifyPasswordCode":
        "/os_kernel_userorgctr/app/user/getVerificationCode", //修改密码获取验证码
    'resetPwdByCode': '/os_kernel_userorgctr/app/user/resetPwdByCode', //修改密码
    "checkNameAndMobile":
        "/os_kernel_bid/app/suppliers/checkNameAndMobile", //校验手机号码与公司名称是否重复
  };
}
