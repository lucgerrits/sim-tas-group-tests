/*
 * Copyright 2017 Bitwise IO, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * -----------------------------------------------------------------------------
 */

use cbor;

use crypto::digest::Digest;
use crypto::sha2::Sha512;

// use std::collections::BTreeMap;
use std::collections::HashMap;
use std::fmt;
use std::io::Cursor;
use std::str;

// use cbor::encoder::GenericEncoder;
// use cbor::value::Key;
// use cbor::value::Text;
// use cbor::value::Value;
// use serde_cbor::to_value;
// use serde_cbor::to_vec;

use sawtooth_sdk::messages::processor::TpProcessRequest;
use sawtooth_sdk::processor::handler::ApplyError;
use sawtooth_sdk::processor::handler::TransactionContext;
use sawtooth_sdk::processor::handler::TransactionHandler;

use serde_json::json;
use serde_json::Value as JsonValue;

#[derive(Copy, Clone)]
enum Cmd {
    NewCar,
    NewOwner,
    Crash,
}

impl fmt::Display for Cmd {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(
            f,
            "{}",
            match *self {
                Cmd::NewCar => "Cmd::NewCar",
                Cmd::NewOwner => "Cmd::NewOwner",
                Cmd::Crash => "Cmd::Crash",
            }
        )
    }
}

fn get_cartp_prefix() -> String {
    let mut sha = Sha512::new();
    sha.input_str("cartp");
    sha.result_str()[..6].to_string()
}

/**
 *
 * cartp payload possibilities:
 * cmd: new_car, new_owner, crash
 * (cmd always required)
 *
 * Parameters for:
 * - new_car: car_brand, car_type, car_licence
 * - new_owner: owner_lastname, owner_name, owner_address, owner_country
 * - crash: accident_ID, signature, dataPublicKey
 *
 *
**/

struct CartpPayload {
    cmd: Cmd,
    car_id: String,
    //for new_car
    factory_id: String,
    car_brand: String,
    car_type: String,
    car_licence: String,
    //for new_owner
    owner_id: String,
    owner_lastname: String,
    owner_name: String,
    owner_address: String,
    owner_country: String,
    //for crash
    // owner_id: String,
    accident_id: String,
    signature: String,
    datapublickey: String,
}

impl CartpPayload {
    pub fn new(payload_data: &[u8]) -> Result<Option<CartpPayload>, ApplyError> {
        let input = Cursor::new(payload_data);

        let mut decoder = cbor::GenericDecoder::new(cbor::Config::default(), input);
        let decoder_value = decoder
            .value()
            .map_err(|err| ApplyError::InternalError(format!("{}", err)))?;

        let c = cbor::value::Cursor::new(&decoder_value);

        let cmd_raw: String = match c.field("tnx_cmd").text_plain() {
            None => {
                return Err(ApplyError::InvalidTransaction(String::from(
                    "cmd parameter is required",
                )));
            }
            Some(cmd_raw) => cmd_raw.clone(),
        };

        let cmd = match cmd_raw.as_str() {
            "new_car" => Cmd::NewCar,
            "new_owner" => Cmd::NewOwner,
            "crash" => Cmd::Crash,
            _ => {
                return Err(ApplyError::InvalidTransaction(String::from(
                    "Cmd must be 'new_car', 'new_owner', or 'crash'",
                )));
            }
        };
        let car_id_raw: String = match c.field("car_id").text_plain() {
            None => String::from(""),
            // None => {
            // return Err(ApplyError::InvalidTransaction(String::from(
            //     "car_brand must be a string",
            // )));
            // }
            Some(car_id_raw) => car_id_raw.clone(),
        };
        //----------------------------for new_car
        let factory_id_raw: String = match c.field("factory_id").text_plain() {
            None => String::from(""), //ignore all none values for testing purposes
            Some(factory_id_raw) => factory_id_raw.clone(),
        };
        let car_brand_raw: String = match c.field("car_brand").text_plain() {
            None => String::from(""), //ignore all none values for testing purposes
            Some(car_brand_raw) => car_brand_raw.clone(),
        };
        let car_type_raw: String = match c.field("car_type").text_plain() {
            None => String::from(""),
            Some(car_type_raw) => car_type_raw.clone(),
        };
        let car_licence_raw: String = match c.field("car_licence").text_plain() {
            None => String::from(""),
            Some(car_licence_raw) => car_licence_raw.clone(),
        };
        //----------------------------for new_owner
        let owner_id_raw: String = match c.field("owner_id").text_plain() {
            None => String::from(""), //ignore all none values for testing purposes
            Some(owner_id_raw) => owner_id_raw.clone(),
        };
        let owner_lastname_raw: String = match c.field("owner_lastname").text_plain() {
            None => String::from(""),
            Some(owner_lastname_raw) => owner_lastname_raw.clone(),
        };
        let owner_name_raw: String = match c.field("owner_name").text_plain() {
            None => String::from(""),
            Some(owner_name_raw) => owner_name_raw.clone(),
        };
        let owner_address_raw: String = match c.field("owner_address").text_plain() {
            None => String::from(""),
            Some(owner_address_raw) => owner_address_raw.clone(),
        };
        let owner_country_raw: String = match c.field("owner_country").text_plain() {
            None => String::from(""),
            Some(owner_country_raw) => owner_country_raw.clone(),
        };
        //----------------------------for crash
        let accident_id_raw: String = match c.field("accident_ID").text_plain() {
            None => String::from(""),
            Some(accident_id_raw) => accident_id_raw.clone(),
        };
        let signature_raw: String = match c.field("signature").text_plain() {
            None => String::from(""),
            Some(signature_raw) => signature_raw.clone(),
        };
        let datapublickey_raw: String = match c.field("dataPublicKey").text_plain() {
            None => String::from(""),
            Some(datapublickey_raw) => datapublickey_raw.clone(),
        };
        //----------------------------for crash
        let cartp_payload = CartpPayload {
            cmd,
            car_id: car_id_raw,
            //for new_car
            factory_id: factory_id_raw,
            car_brand: car_brand_raw,
            car_type: car_type_raw,
            car_licence: car_licence_raw,
            //for new_owner
            owner_id: owner_id_raw,
            owner_lastname: owner_lastname_raw,
            owner_name: owner_name_raw,
            owner_address: owner_address_raw,
            owner_country: owner_country_raw,
            //for crash
            accident_id: accident_id_raw,
            signature: signature_raw,
            datapublickey: datapublickey_raw,
        };
        Ok(Some(cartp_payload))
    }

    pub fn get_cmd(&self) -> Cmd {
        self.cmd
    }
    pub fn get_car_id(&self) -> &String {
        &self.car_id
    }
    pub fn get_factory_id(&self) -> &String {
        &self.factory_id
    }
    pub fn get_car_brand(&self) -> &String {
        &self.car_brand
    }
    pub fn get_car_type(&self) -> &String {
        &self.car_type
    }
    pub fn get_car_licence(&self) -> &String {
        &self.car_licence
    }
    pub fn get_owner_id(&self) -> &String {
        &self.owner_id
    }
    pub fn get_owner_lastname(&self) -> &String {
        &self.owner_lastname
    }
    pub fn get_owner_name(&self) -> &String {
        &self.owner_name
    }
    pub fn get_owner_address(&self) -> &String {
        &self.owner_address
    }
    pub fn get_owner_country(&self) -> &String {
        &self.owner_country
    }
    pub fn get_accident_id(&self) -> &String {
        &self.accident_id
    }
    pub fn get_signature(&self) -> &String {
        &self.signature
    }
    pub fn get_datapublickey(&self) -> &String {
        &self.datapublickey
    }
}

impl fmt::Display for CartpPayload {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self.cmd {
            Cmd::NewCar => {
                write!(
                    f,
                    "(cmd:{}, card_id:{}, factory_id:{}, car_brand:{}, car_type:{}, car_licence:{})",
                    self.get_cmd(),
                    self.get_car_id(),
                    self.get_factory_id(),
                    self.get_car_brand(),
                    self.get_car_type(),
                    self.get_car_licence()
                )
            }
            Cmd::NewOwner => {
                write!(
                    f,
                    "(cmd:{}, card_id:{}, owner_id:{}, owner_lastname:{}, owner_name:{}, owner_address:{}, owner_country:{})",
                    self.get_cmd(),
                    self.get_car_id(),
                    self.get_owner_id(),
                    self.get_owner_lastname(),
                    self.get_owner_name(),
                    self.get_owner_address(),
                    self.get_owner_country()
                )
            }
            Cmd::Crash => {
                write!(
                    f,
                    "(cmd:{}, card_id:{}, owner_id:{}, accident_ID:{}, signature:{}, dataPublicKey:{})",
                    self.get_cmd(),
                    self.get_car_id(),
                    self.get_owner_id(),
                    self.get_accident_id(),
                    self.get_signature(),
                    self.get_datapublickey()
                )
            } // _ => {
              //     write!(
              //         f,
              //         "ERROR: cannot display, Cmd must be 'new_car', 'new_owner', or 'crash'"
              //     )
              // }
        }
    }
}

pub struct CartpState<'a> {
    context: &'a mut dyn TransactionContext,
    address_map: HashMap<String, Option<String>>, //we have addresses with a key and the value is a string (= a json string)
}

impl<'a> CartpState<'a> {
    pub fn new(context: &'a mut dyn TransactionContext) -> CartpState {
        CartpState {
            context,
            address_map: HashMap::new(),
        }
    }

    fn calculate_address(data_type: &str, car_id: &str) -> String {
        let n = vec!["car", "owner", "crash"];
        if n.iter().any(|&i| i == data_type) {
            let mut data_type_sha = Sha512::new();
            data_type_sha.input(data_type.as_bytes());

            let mut car_id_sha = Sha512::new();
            car_id_sha.input(car_id.as_bytes());

            return get_cartp_prefix()
                + &data_type_sha.result_str()[..4].to_string()
                + &car_id_sha.result_str()[..60].to_string();
        } else if data_type == "factory_settings" {
            return String::from(
                "000000a87cb5eafdcca6a89a6f6aa92a4b7cb206c8aaa93d80a76817373ca1c7634a4b",
            );
        } else {
            return String::from("");
        }
    }
    pub fn get(&mut self, data_type: &str, id: &str) -> Result<Option<JsonValue>, ApplyError> {
        let address = CartpState::calculate_address(data_type, id);
        let d = self.context.get_state_entry(&address)?;
        match d {
            Some(state_bytes) => {
                let json_val: JsonValue =
                    serde_json::from_str(str::from_utf8(&state_bytes).unwrap()).map_err(|e| {
                        ApplyError::InvalidTransaction(format!(
                            "Invalid serialization of json state: {}",
                            e
                        ))
                    })?;
                Ok(Some(json_val))
            }
            None => Ok(Some(json!(null))),
        }
    }
    pub fn set(&mut self, data_type: &str, id: &str, value: JsonValue) -> Result<(), ApplyError> {
        let address = CartpState::calculate_address(data_type, id);
        let state_string: String = value.to_string();
        self.address_map
            .insert(address.clone(), Some(state_string.clone()));
        self.context
            .set_state_entry(address, state_string.into_bytes())?;
        Ok(())
    }
}

pub struct CartpTransactionHandler {
    family_name: String,
    family_versions: Vec<String>,
    namespaces: Vec<String>,
}

impl CartpTransactionHandler {
    pub fn new() -> CartpTransactionHandler {
        CartpTransactionHandler {
            family_name: "cartp".to_string(),
            family_versions: vec!["1.0".to_string()],
            namespaces: vec![get_cartp_prefix()],
        }
    }
}

impl TransactionHandler for CartpTransactionHandler {
    fn family_name(&self) -> String {
        self.family_name.clone()
    }

    fn family_versions(&self) -> Vec<String> {
        self.family_versions.clone()
    }

    fn namespaces(&self) -> Vec<String> {
        self.namespaces.clone()
    }

    fn apply(
        &self,
        request: &TpProcessRequest,
        context: &mut dyn TransactionContext,
    ) -> Result<(), ApplyError> {
        let payload = CartpPayload::new(request.get_payload());
        let payload = match payload {
            Err(e) => return Err(e),
            Ok(payload) => payload,
        };
        let payload = match payload {
            Some(x) => x,
            None => {
                return Err(ApplyError::InvalidTransaction(String::from(
                    "Request must contain a payload",
                )));
            }
        };

        let mut state = CartpState::new(context);

        info!(
            // "payload: {} {} {}",
            "payload: {}",
            payload,
            // request.get_header().get_inputs(),
            // request.get_header().get_outputs()
        );

        match payload.get_cmd() {
            Cmd::NewCar => {
                //if factory exists
                //TODO: skip for now, because need to add exception in get state for "factory_id"

                // if car exist
                let state_data = state.get("car", payload.get_car_id());
                match state_data {
                    Ok(Some(JsonValue::Object(_)))
                    | Ok(Some(JsonValue::String(_)))
                    | Ok(Some(JsonValue::Bool(_)))
                    | Ok(Some(JsonValue::Array(_)))
                    | Ok(Some(JsonValue::Number(_))) => {
                        return Err(ApplyError::InvalidTransaction(format!(
                            "ERROR: Already exists: car_id: {}, car_data: \n{}",
                            payload.get_car_id(),
                            state_data.unwrap().unwrap().to_string()
                        )));
                    }
                    Ok(Some(JsonValue::Null)) | Ok(None) => {
                        return state.set(
                            "car",
                            payload.get_car_id(),
                            json!({
                                "data": { //add "data" to getsame structure as python TP version
                                    "factory_id": payload.get_factory_id(),
                                    "car_id": payload.get_car_id(),
                                    "car_brand": payload.get_car_brand(),
                                    "car_type": payload.get_car_type(),
                                    "car_licence": payload.get_car_licence()
                                }
                            }),
                        );
                    }
                    Err(err) => return Err(err),
                };
            }
            Cmd::NewOwner => {
                // if car exist
                match state.get("car", payload.get_car_id()) {
                    Ok(Some(JsonValue::Null)) | Ok(None) => {
                        //error if no car
                        return Err(ApplyError::InvalidTransaction(format!(
                            "'ERROR: Car not exists: car_id: {}",
                            payload.get_car_id()
                        )));
                    }
                    Ok(Some(_)) => (),
                    Err(err) => return Err(err),
                };
                // if already owner
                match state.get("owner", payload.get_car_id()) {
                    Ok(Some(JsonValue::Null)) | Ok(None) => (),
                    Ok(Some(_)) => {
                        return Err(ApplyError::InvalidTransaction(format!(
                            "ERROR: Already owner of car_id: {} owner_id: {}",
                            payload.get_car_id(),
                            payload.get_owner_id()
                        )));
                    },
                    Err(err) => return Err(err),
                };
                state.set(
                    "owner",
                    payload.get_car_id(),
                    json!({
                        "data": { //add "data" to getsame structure as python TP version
                            "car_id": payload.get_car_id(),
                            "owner_id": payload.get_owner_id(),
                            "owner_lastname": payload.get_owner_lastname(),
                            "owner_name": payload.get_owner_name(),
                            "owner_address": payload.get_owner_address(),
                            "owner_country": payload.get_owner_country()
                        }
                    }),
                )
            }
            Cmd::Crash => {
                // if car exist
                match state.get("car", payload.get_car_id()) {
                    Ok(Some(JsonValue::Null)) | Ok(None) => {
                        //error if no car
                        return Err(ApplyError::InvalidTransaction(format!(
                            "'ERROR: Car not exists: car_id: {}",
                            payload.get_car_id()
                        )));
                    },
                    Ok(Some(_)) => (),
                    Err(err) => return Err(err)
                };

                match state.get("crash", payload.get_car_id()) {
                    //get crashes for car_id
                    Ok(Some(JsonValue::Null)) | Ok(None) => {
                        //create and init list of car crashes
                        state.set(
                            "crash",
                            payload.get_car_id(),
                            json!({
                                "data": [
                                    request.get_signature()
                                ]
                            }),
                        )?;
                        ()
                    },
                    Ok(Some(mut crash_car)) => {
                        //append to already existing list of car crashes
                        let data_array = crash_car["data"].as_array_mut().unwrap();
                        data_array.append(&mut vec![JsonValue::from(request.get_signature())]);
                        state.set("crash", payload.get_car_id(), json!({ "data": data_array }))?;
                        ()
                    },                    
                    Err(err) => return Err(err),
                };

                match state.get("crash", payload.get_owner_id()) {
                    //get crashes for owner_id
                    Ok(Some(JsonValue::Null)) | Ok(None) => {
                        //create and init list of owner crashes
                        return state.set(
                            "crash",
                            payload.get_owner_id(),
                            json!({
                                "data": [
                                    request.get_signature()
                                ]
                            }),
                        );
                    },
                    Ok(Some(mut crash_owner)) => {
                        //append to already existing list of owner crashes
                        let data_array = crash_owner["data"].as_array_mut().unwrap();
                        data_array.append(&mut vec![JsonValue::from(request.get_signature())]);
                        return state.set(
                            "crash",
                            payload.get_owner_id(),
                            json!({ "data": data_array }),
                        );
                    },
                    Err(err) => return Err(err),
                };
            }
        }
    }
}
