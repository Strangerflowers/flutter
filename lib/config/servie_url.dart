// const serviceUrl = 'http://osapi-dev.gtland.cn';
final isProd = const bool.fromEnvironment('dart.vm.product');
const serviceUrl = 'http://osapi-dev.gtland.cn';
const updateServiceUrl = 'http://api-dev.gtland.cn';
// const updateServiceUrl = "https://api-pre.myutopa.com";
// const localUrl = 'http://10.10.25.73:8010';
const localUrl = "http://10.10.25.99:8010";

const servicePath = {
  "getKey": 'https://up-z2.qbox.me/',
  'getpictrueToken':
      updateServiceUrl + '/kernel-comm/api/qiniu/getToken', //获取请七牛云token
  'login':
      serviceUrl + '/os_kernel_authcctr/app/authcctr/authc/tgt/login', // 通过账号登录
  'getToken': serviceUrl +
      '/os_kernel_authcctr/app/authc/token/getAndSetTime', //获取token
  'sendResetPwdCaptcha':
      serviceUrl + '/os_kernel_userorgctr/app/user/sendLoginCaptcha', //登录获取验证码
  'sendRegCaptcha': serviceUrl +
      '/os_kernel_userorgctr/app/user/sendRegCaptcha', //注册获取验证码的话访问用户中心的
  "register": serviceUrl + '/os_kernel_bid/app/suppliers/register', //注册接口
  'verifyRegCheckCode': serviceUrl +
      '/os_kernel_userorgctr/app/user/verifyRegCheckCode', //登录校验验证码
  'checkAuditStatus': serviceUrl +
      '/os_kernel_bid/app/suppliers/user/info', //查看返回的auditStatus的状态来判断跳转到哪个页面
  'getCategory': serviceUrl + '/os_kernel_bid/mall/category', //获取供应商类型

  'quotationQueryPage':
      serviceUrl + '/os_kernel_bid/mp/purchase/quotation/queryPage', //报价列表查询
  'quotationDetail':
      serviceUrl + '/os_kernel_bid/mp/purchase/quotation/info', //报价单详情
  'quotationDetailPlan': serviceUrl +
      '/os_kernel_bid/mp/purchase/quotation/demand', //报价单查询所属的采购计划单详情App
  "goodsList": serviceUrl + '/os_kernel_bid/goods/list', //商品库列表
  'goodsDetail':
      serviceUrl + '/os_kernel_bid/goods/info/1', //获取商品详情(包括spu、sku规格信息)
  'listDemand':
      serviceUrl + '/os_kernel_bid/app/suppliers/listDemand', //供应商app-采购-需求列表
  "demandDetail":
      serviceUrl + '/os_kernel_bid/app/suppliers/demandDetail', //供应商app-采购-需求详情
  'soQueryPage':
      serviceUrl + '/os_kernel_bid/mp/bid/suborder/soQueryPage', //销售订单分页查询(列表)
  'queryById':
      serviceUrl + '/os_kernel_bid/mp/bid/suborder/queryById', //销售订单详情查询
  'queryItemById':
      serviceUrl + '/os_kernel_bid/mp/bid/suborder/queryItemById', //添加发货商品展示
  'dispatchAdd': serviceUrl + '/os_kernel_bid/mp/bid/dispatch/add', //添加发货安排
  'confirm': serviceUrl + '/os_kernel_bid/mp/bid/dispatch/confirm', //确认发货安排
  'showDispatchProduct': serviceUrl +
      '/os_kernel_bid/mp/bid/dispatch/showDispatchProduct', //查询发货单商品信息
  'update': serviceUrl + '/os_kernel_bid/mp/bid/dispatch/update', //修改发货安排
  'look': serviceUrl + '/os_kernel_bid/mp/bid/dispatch/queryById', //查询发货单详细信息
  'quoteNow':
      serviceUrl + '/os_kernel_bid/app/suppliers/quoteNow', //供应商app-立即报价
  'selectGoodsByProductId': serviceUrl +
      '/os_kernel_bid/app/suppliers/selectGoodsByProductId', //供应商app-供应商选择报价产品
  'createDemandQuotation':
      serviceUrl + '/os_kernel_bid/app/suppliers/createDemandQuotation', //提交报价
  'getWithdrawAddress':
      serviceUrl + '/os_kernel_bid/app/address/queryPage', // 个人中心-退货地址
  'getCertificationInfo':
      serviceUrl + '/os_kernel_bid/app/suppliers/user/info', // 个人中心-认证资料
  'offline': serviceUrl + '/os_kernel_bid/goods/offline', //下架商品
  'online': serviceUrl + '/os_kernel_bid/goods/online', //上架商品
  'suppliersUpdate':
      serviceUrl + '/os_kernel_bid/app/suppliers/user/update', //更新供应商数据
  'getAddress':
      serviceUrl + '/os_kernel_appsysctr/app/district/loadDistrict', //获取地址
};
