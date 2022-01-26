class CustomResponse{
    constructor() {
        this.status = true;
        this.message = "";
    }

    setMessage(message){
        this.message = message;
    }

    hasError(message){
        this.status = false;
        this.setMessage(message);
    }

}

module.exports = CustomResponse;