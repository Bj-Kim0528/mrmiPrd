// card_collections.js
document.addEventListener("turbolinks:load", function() {
  var container = document.getElementById("file_fields_container");
  var addButton = document.getElementById("add_photo_field");
  var removeButton = document.getElementById("remove_photo_field");
  var submitBtn = document.getElementById("submit_btn");
  var maxFields = 10;

  // 초기 버튼 상태 업데이트
  updateButtons();
  updateSubmitButton();

  // + 버튼 클릭: 숨겨진 다음 입력 필드를 찾아 보이게 함
  addButton.addEventListener("click", function(e) {
    e.preventDefault();
    var fileFields = container.querySelectorAll('div[data-index]');
    var hiddenField = Array.from(fileFields).find(function(field) {
      return field.style.display === "none";
    });
    if (hiddenField) {
      hiddenField.style.display = "";
    }
    updateButtons();
    updateSubmitButton();
  });

  // - 버튼 클릭: 가장 마지막에 보이는 입력 필드(단, 첫 번째 제외)를 숨김 처리
  removeButton.addEventListener("click", function(e) {
    e.preventDefault();
    var fileFields = Array.from(container.querySelectorAll('div[data-index]')).filter(function(field) {
      return field.style.display !== "none";
    });
    if (fileFields.length > 1) {
      var lastVisible = fileFields[fileFields.length - 1];
      var input = lastVisible.querySelector('input[type="file"]');
      if (input) { input.value = ""; }
      lastVisible.style.display = "none";
    }
    updateButtons();
    updateSubmitButton();
  });

  // 각 파일 입력 필드의 change 이벤트 처리
  var fileInputs = container.querySelectorAll('input[type="file"][name="card_collection[photos][]"]');
  fileInputs.forEach(function(input) {
    input.addEventListener("change", function(e) {
      var index = input.parentNode.getAttribute("data-index");
      var previewDiv = document.getElementById("preview_" + index);
      previewDiv.innerHTML = "";
      
      if (input.files && input.files.length > 0) {
        var file = input.files[0];
        var reader = new FileReader();
        reader.onload = function(e) {
          var img = document.createElement("img");
          img.src = e.target.result;
          img.style.maxWidth = "200px";
          img.style.display = "block";
          
          var deleteButton = document.createElement("button");
          deleteButton.type = "button";
          deleteButton.textContent = "삭제";
          deleteButton.addEventListener("click", function() {
            if (index === "0") {
              // 첫 번째 입력 필드: 미리보기만 제거하고 값 초기화, 입력 필드는 그대로 보임
              input.value = "";
              previewDiv.innerHTML = "";
            } else {
              // 두 번째 이후: 해당 입력 필드(부모 div) 숨김 처리 및 값 초기화
              input.value = "";
              input.parentNode.style.display = "none";
              previewDiv.innerHTML = "";
              addButton.disabled = false;
            }
            updateSubmitButton();
          });
          
          previewDiv.appendChild(img);
          previewDiv.appendChild(deleteButton);
        };
        reader.readAsDataURL(file);
        // 자동으로 다음 숨겨진 입력 필드가 보이도록 함 (있다면)
        var fileFields = container.querySelectorAll('div[data-index]');
        var hiddenField = Array.from(fileFields).find(function(field) {
          return field.style.display === "none";
        });
        if (hiddenField) {
          hiddenField.style.display = "";
        }
        updateButtons();
        updateSubmitButton();
      }
    });
  });

  // +, - 버튼 상태 업데이트 함수
  function updateButtons() {
    var fileFields = container.querySelectorAll('div[data-index]');
    if (Array.from(fileFields).every(function(field) { return field.style.display !== "none"; })) {
      addButton.disabled = true;
    } else {
      addButton.disabled = false;
    }
    var visibleFields = Array.from(fileFields).filter(function(field) {
      return field.style.display !== "none";
    });
    removeButton.disabled = (visibleFields.length <= 1);
  }

  // 제출 버튼 상태 업데이트 함수: 하나라도 파일이 선택되었으면 활성화
  function updateSubmitButton() {
    var allInputs = container.querySelectorAll('input[type="file"][name="card_collection[photos][]"]');
    var attached = Array.from(allInputs).some(function(input) {
      return input.value.trim() !== "";
    });
    submitBtn.disabled = !attached;
  }
});
