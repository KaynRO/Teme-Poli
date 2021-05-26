const jwt = require('jsonwebtoken');
const User = require('../models/User');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');
const crypto = require('crypto');
const sendMail = require('../utils/email');

const signToken = (user) => {
   const id = user._id;
   return jwt.sign({ id }, process.env.JWT_SECRET, {
      // payload + secret + expire time
      expiresIn: process.env.JWT_EXPIRES_IN,
   });
};

// cookie a small piece of text that a server sends to
const creatsendToken = (user, statusCode, res) => {
   const token = signToken(user);
   const cookieOptions = {
      expires: new Date(
         Date.now() +
            process.env.JWT_COOKIE_EXPIRES_IN * 24 * 60 * 60 * 1000
      ), // converting to milisec
      httpOnly: true,
   };
   if (process.env.NODE_ENV === 'production')
      cookieOptions.secure = true;
   res.cookie('jwt', token, cookieOptions);
   // Remove the password from output
   user.password = undefined;
   res.status(statusCode).json({
      status: 'success',
      token,
      user,
   });
};

exports.signup = catchAsync(async (req, res, next) => {
   let user = await User.create(req.body);
   console.log(user);
   // Generate Account Activation Link
   const activationToken = user.createAccountActivationLink();

   user.save({ validateBeforeSave: false });

   // 4 Send it to Users Email
   const activationURL = `${req.headers.origin}/confirmMail/${activationToken}`;

   const message = `GO to this link to activate your twitter Account : ${activationURL}`;

   sendMail({
      email: user.email,
      message,
      subject: 'Your Account Activation Link for twitter App !',
      user,
      template: 'signupEmail.ejs',
      url: activationURL,
   });

   res.status(201).json({
      status: 'success',
      user,
   });

   // creatsendToken(user, 201, res);
});

exports.login = catchAsync(async (req, res, next) => {
   const { email, password } = req.body;
   console.log(email);

   if (!email || !password) {
      //  check email and password exist
      return next(
         new AppError(' please proveide email and password ', 400)
      );
   }

   const user = await User.findOne({ email }).select('+password'); // select expiclity password

   if (!user)
      return next(
         new AppError(`No User found against email ${email}`, 404)
      );
   if (
      !user || // check user exist and password correct
      !(await user.correctPassword(password, user.password))
   ) {
      // candinate password,correctpassword
      return next(new AppError('incorrect email or password', 401));
   }

   if (user.activated === false)
      return next(
         new AppError(
            `Plz Activate your email by then Link sent to your email ${user.email}`,
            401
         )
      );

   console.log(`user._id`, user._id);
   creatsendToken(user, 200, res);
});

exports.confirmMail = catchAsync(async (req, res) => {
   // 1 Hash The Avtivation Link
   console.log(req.params.activationLink);

   const hashedToken = crypto
      .createHash('sha256')
      .update(req.params.activationLink)
      .digest('hex');

   // console.log(hashedToken);

   const user = await User.findOne({
      activationLink: hashedToken,
   });

   if (!user)
      return next(
         new AppError(`Activation Link Invalid or Expired !`)
      );
   // 3 Activate his Account
   user.activated = true;
   user.activationLink = undefined;
   await user.save({ validateBeforeSave: false });

   creatsendToken(user, 200, res);
});

exports.me = catchAsync(async (req, res, next) => {
   console.log('req.user._id', req.user._id);
   req.params.id = req.user._id;
   next();
});
