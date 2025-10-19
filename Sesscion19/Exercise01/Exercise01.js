let users = JSON.parse(localStorage.getItem('users')) || [];

let form = document.getElementById('form');

let errorEmail = document.querySelector('.error-email');
let errorPassword = document.querySelector('.error-password');
let errorConfirmPassword = document.querySelector('.error-confirm-password');

form.onsubmit = function (e) {
  e.preventDefault();
  if (validateData(form)) {
    const newUser = {
      id: Math.floor(Math.random() * 10000),
      email: form.email.value,
      password: form.password.value,
    };
    users.push(newUser);
    localStorage.setItem('users', JSON.stringify(users));
  }
};

function validateData(form) {
  let check = true;
  // validate email
  if (form.email.value === '') {
    // trường hợp email để trống
    errorEmail.innerText = 'Email không được để trống';
    check = false;
  } else if (!validEmail(form.email.value)) {
    // kiểm tra validate email hợp lệ bằng pattern (regex)
    errorEmail.innerText = 'Email không hợp lệ';
    check = false;
  } else {
    errorEmail.innerText = '';
  }
  // validate password
  if (form.password.value === '') {
    // trường hợp password để trống
    errorPassword.innerText = 'Password không được để trống';
    check = false;
  } else if (!validPassword(form.password.value)) {
    // kiểm tra validate password hợp lệ bằng pattern (regex)
    errorPassword.innerText = 'Password không hợp lệ';
    check = false;
  } else {
    errorPassword.innerText = '';
  }
  // validate confirm password
  if (form.confirmPassword.value === '') {
    // trường hợp confirm passwor để trống
    errorConfirmPassword.innerText = 'Xác nhận mật khẩu không được để trống';
    check = false;
  } else if (form.password.value !== form.confirmPassword.value) {
    // kiểm tra password và confirm password có trùng khớp hay không
    errorConfirmPassword.innerText = 'Xác nhận mật khẩu không trùng khớp';
    check = false;
  } else {
    errorConfirmPassword.innerText = '';
  }
  return check;
}

function validEmail(email) {
  // sử dụng regex -> regular expression
  return /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(email);
}

function validPassword(password) {
  return /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/.test(password);
}