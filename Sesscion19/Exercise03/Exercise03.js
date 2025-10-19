let showPassword = document.querySelector('.show-password');
let inputPassword = document.querySelector('#password');
showPassword.onclick = function () {
  if (inputPassword.getAttribute('type') === 'password') {
    inputPassword.setAttribute('type', 'text');
  } else {
    inputPassword.setAttribute('type', 'password');
  }
};

let users = JSON.parse(localStorage.getItem('users')) || [];

let form = document.getElementById('form');

let errorEmail = document.querySelector('.error-email');
let errorPassword = document.querySelector('.error-password');

form.onsubmit = function (e) {
  e.preventDefault();
  if (validateData(form)) {
    if (checkEmailAndPassword(form.email.value, form.password.value)) {
      alert('Đăng nhập thành công');
    } else {
      alert('Email hoặc mật khẩu sai');
    }
  }
};

function checkEmailAndPassword(email, password) {
  return users.some((el) => el.email === email && el.password === password);
}

function validateData(form) {
  let check = true;
  if (form.email.value === '') {
    errorEmail.innerText = 'Email không được để trống';
    check = false;
  } else if (!validEmail(form.email.value)) {
    errorEmail.innerText = 'Email không hợp lệ';
    check = false;
  } else {
    errorEmail.innerText = '';
  }
  if (form.password.value === '') {
    errorPassword.innerText = 'Password không được để trống';
    check = false;
  } else if (!validPassword(form.password.value)) {
    errorPassword.innerText = 'Password không hợp lệ';
    check = false;
  } else {
    errorPassword.innerText = '';
  }
  return check;
}

function validEmail(email) {
  return /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(email);
}

function validPassword(password) {
  return /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/.test(password);
}