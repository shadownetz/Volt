class CustomResponse{
    constructor() {
        this.status = true;
        this.message = "";
        this.data = {};
    }

    setMessage(message){
        this.message = message;
    }

    setData(data){
        this.data = data;
    }

    hasError(message){
        this.status = false;
        this.setMessage(message);
    }

}

module.exports = CustomResponse;