const JWT = require("jsonwebtoken");

/**
 * Authentication Middleware
 */
class Auth {
    /**
     * Validate api access
     * @param {Request} req
     * @param {Response} res
     * @param {Function} next
     * @constructor
     */
    static API_ACCESS = function(req, res, next) {
        const _clientKey = req.header("API-KEY");
        if (_clientKey) {
            if (_clientKey !== process.env.API_KEY) return res.status(401).send("Unauthorized Access!");
            else next();
        } else {
            return res.status(404).send("API key not provided");
        }
    }

    /**
     * Validate JWT Token
     * @param {Request} req
     * @param {Response} res
     * @param {Function} next
     * @returns {*}
     * @constructor
     */
    static JWT_ACCESS = function(req, res, next) {
        const JWT_TOKEN = req.header("X-ACCESS-TOKEN");
        if (JWT_TOKEN) {
            try{
                req.body._app = JWT.verify(JWT_TOKEN, process.env.JWT_KEY);
                next();
            }catch (e){
                return res.status(401).send("Invalid Token");
            }
        } else {
            return res.status(403).send("An access token is required for authentication");
        }
    }
}

module.exports = Auth;