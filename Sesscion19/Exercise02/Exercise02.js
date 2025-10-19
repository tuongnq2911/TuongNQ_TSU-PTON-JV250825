const courses = [
    {
        id: 1,
        content: 'Learn Javascript Session 01',
        dueDate: '2023-04-17',
        status: 'Pending',
        assignedTo: 'Anh Bách',
    },
    {
        id: 2,
        content: 'Learn Javascript Session 2',
        dueDate: '2023-04-17',
        status: 'Pending',
        assignedTo: 'Lâm th`',
    },
    {
        id: 3,
        content: 'Learn CSS Session 1',
        dueDate: '2023-04-17',
        status: 'Pending',
        assignedTo: 'Hiếu Ci ớt ớt',
    },
];

let tbody = document.getElementById('tbody');
function showData() {
    tbody.innerHTML = courses.map(
        (el, index) => `<tr>
              <td>${index + 1}</td>
              <td>${el.content}</td>
              <td>${el.dueDate}</td>
              <td>${el.status}</td>
              <td>${el.assignedTo}</td>
              <td class="action-buttons">
                <button class="btn btn-sm btn-secondary" onclick="showEdit(${el.id})">Sửa</button>
                <button class="btn btn-sm btn-danger" onclick="handleDelete(${el.id})">Xóa</button>
              </td>
            </tr>`,
    )
        .join('');
}

showData();

let form = document.getElementById('form');
form.onsubmit = function (e) {
    e.preventDefault();
    let id = Number(form.courseId.value);
    console.log(id);
    const index = courses.findIndex((el) => el.id === id);
    if (index !== -1) {
        const newEdit = {
            id: id,
            content: form.content.value,
            dueDate: form.dueDate.value,
            status: form.status.value,
            assignedTo: form.assignedTo.value,
        };

        courses[index] = newEdit;
        const button = form.querySelector('button');
        button.innerText = 'Submit';
        form.courseId.value = '';
    } else {
        const newCourse = {
            id: Math.floor(Math.random() * 10000),
            content: form.content.value,
            dueDate: form.dueDate.value,
            status: form.status.value,
            assignedTo: form.assignedTo.value,
        };
        courses.push(newCourse);
    }

    showData();
    form.reset();
};

function handleDelete(id) {
    let index = courses.findIndex((el) => el.id === id);
    if (index !== -1) {
        courses.splice(index, 1);
    } else {
        alert('không tồn tại');
    }
    showData();
}

function showEdit(id) {
    let edit = courses.find((el) => el.id === id);
    let button = form.querySelector('button');
    if (edit) {
        // fill dữ liệu vào form
        form.courseId.value = edit.id;
        form.content.value = edit.content;
        form.dueDate.value = edit.dueDate;
        form.status.value = edit.status;
        form.assignedTo.value = edit.assignedTo;

        // nút -> update
        button.innerText = 'Update';
    }
}